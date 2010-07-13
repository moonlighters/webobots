module EmulationSystem
  module Emulation
    # === Контекст бота
    # Полностью описывает состояние бота во время эмуляции
    class Bot
      include RuntimeElements

      attr_reader :state
      attr_accessor :time

      attr_accessor :rtlib

      # Прямой доступ к стеку не рекомендован, исключительно для тестов
      attr_accessor :stack

      def initialize(ir, x, y, angle, log_func)
        @state = Bot::State.new Point[x,y], angle, 0.0, 0.0, World::MAX_HEALTH
        @log_func = log_func

        @time = 0.0

        # стек элементов выполнения
        # вершина стека - конец массива
        @stack = []
        push_element( ir.root )

        # стековая переменная, через которую можно передовать значения между элементами
        @stack_var = nil
      end

      # Закончено ли выполение?
      def halted?
        @stack.empty? or dead?
      end

      # Жив ли?
      def dead?
        @state.health <= 0
      end

      # Просчитывает шаг физики за время dt
      def calc_physics_for(dt, other_bots=[])
        if @state.speed_mode == :accelerated
          @state.speed += World::ACCELERATION*dt
          @state.speed = @state.desired_speed if @state.speed_mode == :decelerated
        elsif @state.speed_mode == :decelerated
          @state.speed -= World::DECELERATION*dt
          @state.speed = @state.desired_speed if @state.speed_mode == :accelerated
        end

        @state.pos += Vector[@state.cosa, @state.sina]*@state.speed*dt

        collide_with other_bots
        @state.correct
      end

      # Проверяет бота на столкновение с другими ботами и
      # при необходимости корректирует его положение
      def collide_with(other_bots)
        other_bots.each do |bot|
          dist = @state.pos - bot.state.pos
          if dist.abs < 2*World::BOT_RADIUS
            # вытолкнуть наружу: двойной радиус на нормированное направление
            # (если боты в одной точке - выбираем случайное направление)
            direction = if dist.abs == 0
                          a = Kernel::rand()*Math::PI
                          Vector[Math::cos(a), Math::sin(a)]
                        else
                          dist/dist.abs
                        end
            @state.pos = bot.state.pos + direction * 2*World::BOT_RADIUS
          end
        end
      end

      # Возвращает положение бота
      def pos; @state.pos; end

      # Возвращает здоровье бота
      def health; @state.health; end

      # Снимает определенное количество здоровья
      def injure!(x)
        @state.health -= x
      end

      # Выполняет одно атомарное действие,
      # возвращает количество тактов потраченное на выполнение
      def step
        raise "Внутренняя ошибка эмуляции: попытка вызова #step у halted-бота" if halted?
        last = @stack.last.run
        @time += last
        last
      end

      # Добавляет в стек класс элемента,
      # соответствующего данному +node+
      def push_element(node, *args)
        type = case node.data
        when /^\d+$/, /^\d+\.\d+$/, /^"[^"]*"$/ # integer, float or string literal
          Literal
        when 'block'
          Block
        when '='
          Assignment
        when 'if'
          If
        when 'while'
          While
        when 'var'
          Variable
        when /^(?:[-+*\/]|[<>]=?|[!=]=|and|or)$/
          BinaryOp
        when /^(?:uminus|uplus|not)$/
          UnaryOp
        when 'funcdef'
          FuncDef
        when 'funccall'
          FuncCall
        when 'return'
          Return
        when 'log'
          Log
        else
          raise "Внутренняя ошибка емуляции: попытка добавления в стек неизвестного узла '#{node.data}'"
        end
        @stack.push type.new(self, node, *args)
      end

      # Убирает класс элемента со стека
      def pop_element
        @stack.pop
      end

      # Устанавливает стековую переменную
      def push_var(var)
        @stack_var = var
      end

      # Вытаскивает стековую переменную
      def pop_var
        res = @stack_var
        @stack_var = nil
        res
      end

      # Находит ближайший +Block+, лежащий над +elem+.
      # +options+:
      # * +function+ указывает на поиск только функциональных блоков, по умолчанию +false+
      # * +global+ указывает на поиск глобального блока, по умолчанию +false+
      def upper_block_from(elem, options={})
        function = options.delete( :function ) || false
        global = options.delete( :global ) || false
        return @stack[0] if global
        elem_index = @stack.find_index(elem) || @stack.size
        # нужно найти последний Block, среди @run_stack[0,elem_index]
        @stack[0,elem_index].reverse.find {|e| e.is_a?(Block) and (not function or e.function?)}
      end

      # Записывает в лог строку +str+
      def log(str)
        @log_func.call str
      end
    end
  end
end
