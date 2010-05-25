module EmulationSystem
  # == Ошибки, возникающие в EmulationSystem
  module Errors
    # === Синтаксическая ошибка
    # Может возникать при парсинге исходного кода,
    # содержит в себе массив +errors+ с текстовой информацией об ошибках
    class WFLSyntaxError < Exception
      attr :errors

      def initialize(errors)
        super "Syntax errors: " + errors * ";"
        @errors = errors
      end
    end
  end
end
