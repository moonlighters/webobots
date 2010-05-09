module EmulationSystem
  module Parser
    # Делегирует функцию парсинга исходного кода внешнему парсеру и
    # полученое дерево преобразует в IR
    class Parser
      # Принимает исходный код прошивки и
      # возвращает экземляр IR
      # ( TODO а что делать с ошибками? )
      def parse(code)
        res = ANTLRParser.call(code)
        lisp_to_ir( res )
      end

      private
      # Конвертирует Lisp нотацию в дерево для IR
      def lisp_to_ir(tree)
        root_node = IR::Node.new( 'block', [] )
        IR.new( root_node )
      end
    end
  end
end
