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

      def initialize(ir, x, y, angle)
        @state = State.new Point[x,y], angle, 0, 0, World::MAX_HEALTH

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

      # Выполняет одно атомарное действиею
      # Возвращает количество тактов потраченное на выполнение
      def step
        if @stack.empty?
          0
        else
          @stack.last.run
        end
      end

      # Добавляет в стек класс элемента,
      # соответствующего данному +node+
      def push_element(node)
        type = case node.data
        when /^\d+$/, /^\d+\.\d+$/; Number
        when 'block'; Block
        when '=';     Assignment
        when 'if';    If
        when 'id';    Identifier
        end
        @stack.push type.new(self, node)
      end

      # Убирает класс элемента со стека
      def pop_element
        @stack.pop
      end

      # Установить стековую переменную
      def push_var(var)
        @stack_var = var
      end

      # Вытащить стековую переменную
      def pop_var
        res = @stack_var
        @stack_var = nil
        res
      end

      # Находит ближайший Block,
      # лежащий над +elem+
      def upper_block_from(elem)
        elem_index = @stack.find_index(elem) or return nil
        # нужно найти последний Block, среди @run_stack[0,elem_index]
        @stack[0,elem_index].reverse.find {|e| e.is_a? Block }
      end

    end
  end
end
