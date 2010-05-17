module EmulationSystem
  module Emulation
    # === Контекст бота
    # Полностью описывает состояние бота во время эмуляции
    class BotContext
      Vector = Struct.new :x, :y
      Point = Vector

      # === Состояние бота
      # * +pos+ - позиция бота на поле
      # * +angle+ - направление движения бота
      # * +speed+ - модуль мгновенной скорости
      # * +desired_speed+ - конечное значение модуля скорости при разгоне и торможении
      # * +health+ - здоровье
      class State < Struct.new :pos, :angle, :speed, :desired_speed, :health
      end
      
      attr_reader :state, :ir, :time, :variables, :cur_node

      def initialize(ir, x, y, angle)
        @state = State.new Point[x,y], angle, 0, 0, World::MAX_HEALTH

        @ir = ir
        @time = 0

        @variables = {}
        @cur_node = nil
      end
    end
  end
end
