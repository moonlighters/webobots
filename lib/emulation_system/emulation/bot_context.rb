module EmulationSystem
  module Emulation
    # Контекст бота, полностью описывающий его состояние во время эмуляции
    #
    class BotContext
      Vector = Struct.new :x, :y
      Point = Vector

      # Состояние бота
      # * +pos+ - позиция бота на поле
      # * +angle+ - направление движения бота
      # * +speed+ - модуль мгновенной скорости
      # * +desired_speed+ - конечное значение модуля скорости при разгоне и торможении
      # * +health+ - здоровье
      State = Struct.new :pos, :angle, :speed, :desired_speed, :health
      
      attr_reader :state, :ir, :time, :variables, :cur_node

      def initialize(ir, x, y, angle)
        @state = State.new Point[x,y], angle, 0, 0, 1

        @ir = ir
        @time = 0

        @variables = {}
        @cur_node = nil
      end
    end
  end
end
