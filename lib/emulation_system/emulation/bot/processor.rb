module EmulationSystem
  module Emulation
    class Bot
      # === Модуль отвечающий за исполнение кода прошивки бота
      module Processor
        attr_accessor :time
        attr_accessor :rtlib
        attr_reader :stack

        attr_writer :stack if Rails.env.test?

        # Закончено ли выполение?
        def halted?
          @stack.empty?
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
            RuntimeElements::Literal
          when 'block'
            RuntimeElements::Block
          when '='
            RuntimeElements::Assignment
          when 'if'
            RuntimeElements::If
          when 'while'
            RuntimeElements::While
          when 'var'
            RuntimeElements::Variable
          when /^(?:[-+*\/]|[<>]=?|[!=]=|and|or)$/
            RuntimeElements::BinaryOp
          when /^(?:uminus|uplus|not)$/
            RuntimeElements::UnaryOp
          when 'funcdef'
            RuntimeElements::FuncDef
          when 'funccall'
            RuntimeElements::FuncCall
          when 'return'
            RuntimeElements::Return
          when 'log'
            RuntimeElements::Log
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
          @stack[0,elem_index].reverse.find {|e| e.is_a?(RuntimeElements::Block) and (not function or e.function?)}
        end

        # Записывает в лог строку +str+
        def log(str)
          @log_func.call str
        end

        protected

        def initialize_processor(ir, log_func)
          @log_func = log_func
          @time = 0.0

          # стек элементов выполнения
          # вершина стека - конец массива
          @stack = []
          push_element( ir.root )

          # стековая переменная, через которую можно передовать значения между элементами
          @stack_var = nil
        end
      end
    end
  end
end
