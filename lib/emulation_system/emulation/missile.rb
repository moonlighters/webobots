module EmulationSystem
  module Emulation
    # === Боевая ракета
    # * +pos+ - позиция ракеты
    # * +velocity+ - вектор скорости ракеты
    # * +distance+ - пройденный путь
    # * +desired_distance+ - расстояние, на котором ракета должна взорваться
    class Missile
      attr_reader :pos

      # Создает ракету при выстреле
      # * +bot+ - кто стреляет
      # * +radians+ - направление, куда стреляет
      # * +desired_distance+ - расстояние до точки, в которую стреляют
      def initialize(bot, radians, desired_distance)
        direction = Vector[ Math::cos(radians), Math::sin(radians) ]
        @pos = bot.pos + direction*(World::BOT_RADIUS + 1)

        @velocity_x = direction.x * World::MISSILE_SPEED
        @velocity_y = direction.y * World::MISSILE_SPEED
        @distance = 0
        @desired_distance = desired_distance
        @exploded = false
      end

      def explode!
        @exploded = true
      end

      def exploded?
        @exploded
      end

      def calc_physics_for(dt)
        @pos.x += @velocity_x * dt
        @pos.y += @velocity_y * dt
        @distance += World::MISSILE_SPEED * dt

        explode! if @distance >= @desired_distance ||
                    0 > @pos.x || @pos.x > World::FIELD_SIZE ||
                    0 > @pos.y || @pos.y > World::FIELD_SIZE
      end

      # Возвращает врезалась ли ракета в бота
      def hit?(bot)
        (@pos - bot.pos).abs <= World::BOT_RADIUS
      end

      # Наносит ущерб боту в зависимости от расстояния до него
      def injure(bot)
        bot.injure! damage( (bot.pos - @pos).abs - World::BOT_RADIUS )
      end

      private

      # Возвращает урон обратно пропорциональный расстоянию до бота
      def damage(dist)
        return 0                      if dist >= World::EXPLOSION_RADIUS
        return World::MISSILE_DAMAGE  if dist <= 0

        return World::MISSILE_DAMAGE - dist*World::MISSILE_DAMAGE/World::EXPLOSION_RADIUS
      end
    end
  end
end
