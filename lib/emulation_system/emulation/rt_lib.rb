module EmulationSystem
  module Emulation
    # === Класс реализует runtime библиотеку
    # Библиотека необходима для выполнения прошивок ботов
    class RTLib
      # Создает экземпляр класс +RTLib+
      # +options+:
      # * +:for+ - для какого бота
      # * +:against+ - бот-противник
      # * +:vm+ - соответствующая вирт.машина
      def initialize(options)
        @friendly = options[:for]
        @enemy = options[:against]
        @vm = options[:vm]
      end

      # Вызывает системную функцию +func+ с аргументами +@args+,
      # если количество аргументов неверно, кидает +WFLRuntimeError+
      def call(func, *args)
        unless has_function? func
          raise "Внутренняя ошибка эмуляции: попытка вызова неизвестной системной функции #{func}"
        else
          begin
            self.send(func, *args)
          rescue ArgumentError => e
            e.message =~ /\((\d+) for (\d+)\)/
            raise Errors::WFLRuntimeError,
                  "неверное количество аргументов (#{$1} вместо #{$2}) для функции '#{func}'"
          end
        end
      end

      # Проверяет наличие системной функции +func+
      def has_function?(func)
        FUNCTIONS.include? func
      end

      private

      FUNCTIONS = [
        # простые getter'ы
        'posx', 'posy', 'angle', 'speed',
        'desired_speed', 'health', 'time'
      ]

      # координата X
      def posx; @friendly.state.pos.x; end
      # координата Y
      def posy; @friendly.state.pos.y; end
      # направление движения
      def angle; @friendly.state.angle; end
      # текущая скорость
      def speed; @friendly.state.speed; end
      # "желаемая" скорость
      def desired_speed; @friendly.state.desired_speed; end
      # здоровье
      def health; @friendly.state.health; end
      # время прошедшее с начала
      def time; @friendly.time; end
    end
  end
end
