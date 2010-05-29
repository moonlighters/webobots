module EmulationSystem
  # == Логгеры
  # Модуль, содержащий примитивные классы, которые могут быть
  # использованы как логгеры для эмуляции
  module Loggers
    # === "Тупой" логгер
    # Заглушка - логгер, который не сохраняет информацию
    class DummyLogger
      def add_frame(bot1, bot2, env)
      end
      def add_log_record(bot, str)
      end
    end

    # === Логгер записей
    # Логгер, сохраняющий записи
    class RecordListLogger
      # Список записей в формате "<tt>1: ...</tt>"
      attr_reader :records
      
      def initialize
        @records = []
      end

      def add_frame(bot1, bot2, env)
      end

      def add_log_record(bot, str)
        i = bot == :first ? 1 : 2
        @records << "#{i}: " + str
      end
    end
  end
end
