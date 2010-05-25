module EmulationSystem
  module Parsing
    # === Обертка для вызова внешнего парсера ANTLR
    class ANTLRParser
      # Возвращает дерево разбора исходного кода в нотации Lisp
      #
      # Lisp нотация:
      #     (root child child (root child))
      def self.call(code)
        parser = File.join(File.dirname(__FILE__),'antlr_parser','antlr_parser.py')
        output = IO::popen parser, 'w+' do |p|
          p.puts code
          p.close_write
          p.read.strip
        end
        raise Errors::WFLSyntaxError.new(output.split("\n")) if not $?.success?
        output
      end
    end
  end
end
