module EmulationSystem
  module Emulation
    # === Класс реализует runtime библиотеку
    # Библиотека необходима для выполнения прошивок ботов
    class RTLib
      # Создает экземпляр класс +RTLib+
      # +options+:
      # * <tt>:for</tt> - для какого бота
      # * <tt>:against</tt> - бот-противник
      # * <tt>:vm</tt> - соответствующая вирт.машина
      def initialize(options)
        @friendly = options[:for]
        @enemy = options[:against]
        @vm = options[:vm]
      end

      # Вызывает системную функцию +func+ с аргументами +args+,
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
        'sin','cos','atan2','sqr','sqrt' ] # :nodoc:

      # Возвращает координату X бота
      def posx # :doc:
        @friendly.state.pos.x
      end

      # Возвращает координату Y бота
      def posy # :doc:
        @friendly.state.pos.y
      end

      # Возвращает направление движения бота
      def angle # :doc:
        @friendly.state.angle
      end

      # Возвращает текущую скорость бота
      def speed # :doc:
        @friendly.state.speed
      end

      # Возвращает последнюю установленную скорость
      def desired_speed # :doc:
        @friendly.state.desired_speed
      end

      # Возвращает здоровье бота
      def health # :doc:
        @friendly.state.health
      end

      # Возвращает время прошедшее с начала матча
      def time # :doc:
        @friendly.time
      end

      # Устанавливает направление движения бота, если
      # скорость допустима для поворота
      #
      # Возвращает 1, если поворот возможен, 0 - иначе
      def rotate(angle) # :doc:
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
      def set_speed(speed) # :doc:
        @friendly.state.desired_speed = ( speed < 0 ? 0 : ( speed > World::MAX_SPEED ? World::MAX_SPEED : speed) )
        (0..World::MAX_SPEED).include?(speed) ? 1 : 0
      end

      # Бот "засыпает" на +time+ секунд, при этом движение не останавливается
      #
      # Возвращает +time+
      def sleep(time) # :doc:
        @friendly.time += time
        time
      end

      # Возвращает координату X бота-врага
      def enemy_posx # :doc:
        @enemy.state.pos.x
      end

      # Возвращает координату Y бота-врага
      def enemy_posy # :doc:
        @enemy.state.pos.y
      end

      # Выпускает ракету в направлении угла +angle+,
      # которая взрывается либо на расстоянии +distance+, либо
      # от прямого столкновения с вражеским ботом
      #
      # Возвращает 1, если выстрел прошел успешно,
      # 0, если выстрел невозможен из-за огроничения скорострельности
      def fire(angle, distance) # :doc:
        raise "Not yet"
      end

      # внутренний хелпер
      def to_radians(angle_in_degrees); angle_in_degrees * Math::PI / 180; end
      def to_degrees(angle_in_radians); angle_in_radians * 180 / Math::PI; end

      # Вычисляет синус угла, данного в градусах
      def sin(angle) # :doc:
        Math.sin to_radians(angle)
      end

      # Вычисляет косинус угла, данного в градусах
      def cos(angle) # :doc:
        Math.cos to_radians(angle)
      end

      # Вычисляет арктангес по +y+ и +x+
      #
      # Результат лежит в <tt>-180..180</tt>
      def atan2(y,x) # :doc:
        to_degrees Math.atan2(y,x)
      end

      # Вычисляет квадрат аргумента
      def sqr(x) # :doc:
        x * x
      end

      # Вычисляет квадратный корень из аргумента
      #
      # Может кидать +WFLRuntimeError+, если аргумент отрицателен
      def sqrt(x) # :doc:
        raise Errors::WFLRuntimeError, "извлечение квадратного корня из отричательного числа" if x < 0
        Math.sqrt(x)
      end
    end
  end
end
