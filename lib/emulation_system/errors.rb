module EmulationSystem
  # == Ошибки, возникающие в EmulationSystem
  module Errors
    # === Синтаксическая ошибка
    # Может возникать при парсинге исходного кода,
    # содержит в себе массив +errors+ с текстовой информацией об ошибках
    class WFLSyntaxError < Exception
      attr :errors

      def initialize(errors)
        super "Ситаксические ошибки: " + errors * ";"
        @errors = errors
      end
    end

    # === Ошибка времени исполнения
    # Может возникать при интерпретации прошивки,
    # текстовая информация об ошибке в сообщении
    class WFLRuntimeError < Exception
    end
  end
end
