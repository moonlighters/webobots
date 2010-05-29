module EmulationSystem
  module Emulation
    # === Контекст бота
    # Полностью описывает состояние бота во время эмуляции
    class Bot
      include RuntimeElements

      Vector = Struct.new :x, :y
      Point = Vector

      # === Состояние бота
      # * +pos+ - позиция бота на поле
      # * +angle+ - направление движения бота
      # * +speed+ - модуль мгновенной скорости
      # * +desired_speed+ - конечное значение модуля скорости при разгоне и торможении
      # * +health+ - здоровье
      class State < Struct.new :pos, :angle, :speed, :desired_speed, :health
      end
      
      attr_reader :state, :time

      # Прямой доступ к стеку не рекомендован, исключительно для тестов
      attr_accessor :stack

      def initialize(ir, x, y, angle, log_func)
        @state = State.new Point[x,y], angle, 0, 0, World::MAX_HEALTH
        @log_func = log_func

        @time = 0

        # стек элементов выполнения
        # вершина стека - конец массива
        @stack = []
        push_element( ir.root )

        # стековая переменная, через которую можно передовать значения между элементами
        @stack_var = nil
      end

      # Закончено ли выполение?
      def halted?
        @stack.empty?
      end

      # Выполняет одно атомарное действие,
      # возвращает количество тактов потраченное на выполнение
      def step
        @stack.last.run unless @stack.empty?
      end

      # Добавляет в стек класс элемента,
      # соответствующего данному +node+
      def push_element(node, *args)
        type = case node.data
        when /^\d+$/, /^\d+\.\d+$/
          Number
        when 'block'
          Block
        when '='
          Assignment
        when 'if'
          If
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
      # +only_function+ указывает на поиск только функциональных блоков
      def upper_block_from(elem, only_function = false)
        elem_index = @stack.find_index(elem) || @stack.size
        # нужно найти последний Block, среди @run_stack[0,elem_index]
        @stack[0,elem_index].reverse.find {|e| e.is_a?(Block) and (not only_function or e.function?)}
      end

      # Записывает в лог строку +str+
      def log(str)
        @log_func.call str
      end
    end
  end
end
