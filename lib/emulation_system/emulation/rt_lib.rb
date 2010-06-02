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
        'posx','posy','angle','speed',
        'desired_speed','health','time',
        'rotate','set_speed',
        'sleep',
        'enemy_posx','enemy_posy',
        'fire',
      ]

      # Возвращает координату бота X
      def posx; @friendly.state.pos.x; end

      # Возвращает координату бота Y
      def posy; @friendly.state.pos.y; end

      # Возвращает направление движения бота
      def angle; @friendly.state.angle; end

      # Возвращает текущую скорость бота
      def speed; @friendly.state.speed; end

      # Возвращает последнюю установленную скорость
      def desired_speed; @friendly.state.desired_speed; end

      # Возвращает здоровье бота
      def health; @friendly.state.health; end

      # Возвращает время прошедшее с начала матча
      def time; @friendly.time; end

      # Устанавливает направление движения бота, если
      # скорость допустима для поворота
      #
      # Возвращает 1, если поворот возможен, 0 - иначе
      def rotate(angle)
        if @friendly.state.speed <= World::MAX_SPEED_WHEN_ROTATION_POSSIBLE
          @friendly.state.angle = angle
          1
        else
          0
        end
      end

      # Устанавливает скорость, до который бот начнет
      # ускоряться или тормозить
      #
      # Возвращает 1, если скорость не выходит за допустимые пределы,
      # 0 - иначе
      def set_speed(speed)
        @friendly.state.desired_speed = ( speed < 0 ? 0 : ( speed > World::MAX_SPEED ? World::MAX_SPEED : speed) )
        (0..World::MAX_SPEED).include?(speed) ? 1 : 0
      end

      # Бот "засыпает" на +time+ секунд, при этом движение не останавливается
      #
      # Возвращает +time+
      def sleep(time)
        @friendly.time += time
        time
      end

      # Возвращает координату X бота-врага
      def enemy_posx; @enemy.state.pos.x; end

      # Возвращает координату Y бота-врага
      def enemy_posy; @enemy.state.pos.y; end

      # Выпускает ракету в направлении угла +angle+,
      # которая взрывается либо на расстоянии +distance+, либо
      # от прямого столкновения с вражеским ботом
      def fire(angle, distance)
        raise "Not yet"
      end
    end
  end
end
