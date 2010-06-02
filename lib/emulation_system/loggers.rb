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

    # === Логгер для повтора
    # Логгер, сохраняющий кадры и записи
    class ReplayLogger
      attr_reader :frames
      
      def initialize
        @frames = []
      end

      def add_frame(bot1, bot2, env)
        s = Emulation::World::FIELD_SIZE
        h = Emulation::World::MAX_HEALTH
        @frames << {
          'bot1' => { 'x' => bot1.state.pos.x/s,
                      'y' => bot1.state.pos.y/s,
                      'angle' => bot1.state.angle,
                      'health' => bot1.state.health/h },
          'bot2' => { 'x' => bot2.state.pos.x/s,
                      'y' => bot2.state.pos.y/s,
                      'angle' => bot2.state.angle,
                      'health' => bot2.state.health/h },
          'missiles' => env[:missiles].map {|m|
            {
              'id' => m.object_id,
              'x' => m.pos.x/s,
              'y' => m.pos.y/s
            }
          },
          'explosions' => env[:explosions].map {|point|
            {
              'x' => point.x/s,
              'y' => point.y/s
            }
          },
          'log' => [],
          'time' => env[:time]
        }
      end

      def add_log_record(bot, str)
        i = bot == :first ? 'bot1' : 'bot2'
        @frames.last['log'] << [i, str]
      end

      def config
        f = @frames.first
        {
          'bot1' => { 'x' => f['bot1']['x'], 'y' => f['bot1']['y'], 'angle' => f['bot1']['angle'] },
          'bot2' => { 'x' => f['bot2']['x'], 'y' => f['bot2']['y'], 'angle' => f['bot2']['angle'] },
          'bot_radius' => Emulation::World::BOT_RADIUS/Emulation::World::FIELD_SIZE,
          'explosion_radius' => Emulation::World::EXLOSION_RADIUS/Emulation::World::FIELD_SIZE,
          'frame_rate' => Emulation::VM::FRAME_RATE
        }
      end
    end
  end
end
