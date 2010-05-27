module EmulationSystem::Emulation
  # == Хранит информацию об условной длительности выполнения элементов языка
  module Timing
    include RuntimeElements

    def for(elem, action = nil)
      TIMES[elem.is_a?(Class) ? elem : elem.class][action || :default]
    end
    module_function :for

    private
    TIMES = {
      Block => {
        :step => 0,
        :finish => 0
      },
      Assignment => {
        :evaluation => 0,
        :assignment => 5
      },
      Number => {
        :default => 0
      },
      If => {
        :evaluation => 0,
        :finish => 0
      },
      Identifier => {
        :default => 0
      }
    }
  end
end
