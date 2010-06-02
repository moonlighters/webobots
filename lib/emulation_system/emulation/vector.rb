module EmulationSystem
  module Emulation
    class Vector < Struct.new :x, :y
      def +(vector)
        return Vector.new x + vector.x, y + vector.y
      end

      def -@
        return Vector.new -x, -y
      end

      def -(vector)
        return self + (- vector)
      end

      def *(value)
        return Vector.new x*value, y*value
      end

      def *(value)
        return Vector.new x*value, y*value
      end

      def abs
        return Math::sqrt(x**2 + y**2)
      end

      def near_to?(vector, radius)
        (self - vector).abs <= radius
      end
    end
  end
end
