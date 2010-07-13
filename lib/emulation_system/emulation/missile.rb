module EmulationSystem
  module Emulation
    # === Боевая ракета
    # * +pos+ - позиция ракеты
    # * +velocity+ - вектор скорости ракеты
    # * +distance+ - пройденный путь
    # * +desired_distance+ - расстояние, на котором ракета должна взорваться
    class Missile < Struct.new :pos, :velocity, :distance, :desired_distance
      # Создает ракету при выстреле
      # * +bot+ - кто стреляет
      # * +radians+ - направление, куда стреляет
      # * +desired_distance+ - расстояние до точки, в которую стреляют
      def initialize(bot, radians, desired_distance)
        direction = Vector[ Math::cos(radians), Math::sin(radians) ]
        self.pos = bot.pos + direction*(World::BOT_RADIUS + 1)
        
        self.velocity = direction*World::MISSILE_SPEED
        self.distance = 0
        self.desired_distance = desired_distance
        @exploded = false
      end

      def explode!
        @exploded = true
      end
      
      def exploded?
        @exploded
      end
      
      def calc_physics_for(dt)
        return if exploded?

        dr = velocity*dt
        ds = dr.abs
        
        self.pos += dr
        self.distance += ds

        explode! if self.distance >= desired_distance ||
                    [pos.x, pos.y].any? { |q| (0..World::FIELD_SIZE).exclude? q }
      end

      # Возвращает врезалась ли ракета в бота
      def hit?(bot)
        self.pos.near_to? bot.pos, World::BOT_RADIUS
      end

      # Наносит ущерб боту в зависимости от расстояния до него
      def injure(bot)
        bot.injure! damage( (bot.pos - self.pos).abs - World::BOT_RADIUS )
      end

      private

      # Возвращает урон обратно пропорциональный расстоянию до бота
      def damage(dist)
        return World::MISSILE_DAMAGE  if dist <= 0
        return 0                      if dist >= World::EXPLOSION_RADIUS

        return World::MISSILE_DAMAGE - dist*World::MISSILE_DAMAGE/World::EXPLOSION_RADIUS
      end
    end
  end
end
