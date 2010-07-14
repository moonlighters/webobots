module EmulationSystem
  module Emulation
    # === Контекст бота
    # Полностью описывает состояние бота во время эмуляции и
    # предоставляет функционал, необходимый для эмуляции
    class Bot
      include Bot::Engine
      include Bot::Processor

      def initialize(ir, x, y, angle, log_func)
        initialize_engine(x, y, angle)
        initialize_processor(ir, log_func)
      end
    end
  end
end
