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
    # Может возникать при интерпретации прошивки, текстовая информация об ошибке в сообщении,
    # порядковый номер прошивки, вызвавшей ошибку, указан в поле +index+
    class WFLRuntimeError < Exception
      attr_accessor :index
    end
  end
end
