module EmulationSystem
  module Emulation
    class Vector < Struct.new :x, :y
      def +(vector)
        Vector[x + vector.x, y + vector.y]
      end

      def -@
        self * -1
      end

      def -(vector)
        self + (- vector)
      end

      def *(value)
        Vector[x*value, y*value]
      end

      def /(value)
        self * (1/value)
      end

      def abs
        Math::sqrt(x**2 + y**2)
      end

      def near_to?(vector, radius)
        (self - vector).abs <= radius
      end
    end
  end
end
