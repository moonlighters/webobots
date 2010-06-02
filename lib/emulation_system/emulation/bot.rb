module EmulationSystem
  module Emulation
    # === Контекст бота
    # Полностью описывает состояние бота во время эмуляции
    class Bot
      include RuntimeElements

      # === Состояние бота
      # * +pos+ - позиция бота на поле
      # * +angle+ - направление движения бота
      # * +speed+ - модуль мгновенной скорости
      # * +desired_speed+ - конечное значение модуля скорости при разгоне и торможении
      # * +health+ - здоровье
      class State < Struct.new :pos, :angle, :speed, :desired_speed, :health
        def radians
          angle * Math::PI / 180
        end
        
        def radians=(value)
          self.angle = value / Math::PI * 180
        end

        def cosa
          Math::cos(radians)
        end

        def sina
          Math::sin(radians)
        end

        # Просчитывает шаг физики за время dt
        def calc_physics_for(dt)
          if speed < desired_speed
            self.speed += World::ACCELERATION*dt
            self.speed = desired_speed if speed > desired_speed
          elsif speed > desired_speed
            self.speed -= World::DECELERATION*dt
            self.speed = desired_speed if speed < desired_speed
          end
          
          self.pos += Vector[cosa, sina]*speed*dt

          correct_state
        end

        # Корректирует значения координат, скорости и здоровья
        # если они выходят за пределы
        def correct_state
          self.pos.x  = correct_value pos.x,  0, World::FIELD_SIZE
          self.pos.y  = correct_value pos.y,  0, World::FIELD_SIZE
          self.speed  = correct_value speed,  0, World::MAX_SPEED
          self.health = correct_value health, 0, World::MAX_HEALTH
        end

        # Возвращает значение +val+, ограниченное
        # до пределов +min+..+max+
        def correct_value(val, min, max)
          val < min ? min : (val > max ? max : val)
        end
      end
      
      attr_reader :state
      attr_accessor :time

      attr_accessor :rtlib

      # Прямой доступ к стеку не рекомендован, исключительно для тестов
      attr_accessor :stack

      def initialize(ir, x, y, angle, log_func)
        @state = State.new Point[x,y], angle, 0.0, 0.0, World::MAX_HEALTH
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
        @stack.empty? or @state.health <= 0
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
