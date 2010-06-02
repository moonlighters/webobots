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
        self.pos = bot.state.pos + direction*(World::BOT_RADIUS + 1)
        
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
                    [pos.x, pos.y].any? { |q| not (0..World::FIELD_SIZE).include? q }
      end
    end
  end
end
