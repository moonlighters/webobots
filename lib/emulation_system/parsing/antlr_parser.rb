module EmulationSystem::Parsing
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
      raise "Syntax errors:\n" + output if not $?.success?
      output
    end
  end
end
