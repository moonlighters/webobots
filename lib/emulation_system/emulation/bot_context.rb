module EmulationSystem
  module Emulation
    # Контекст бота, полностью описывающий его состояние во время эмуляции
    #
    # Описание игрового мира
    # * поле имеет размеры 1x1
    # * углы отсчитываются в градусах от оси X к оси Y
    # * единица времени - 1 такт
    # * единица скорости - 1 ширина_поля/такт
    # * здоровье бота изменяется от 0 до 1
    # * разгон и торможение происходят с фиксированными ускорениями
    # * ограничена маскимальная скорострельность - 1 выстрел в N тактов
    # * поворот бота возможен на любой угол, если скорость меньше определенной,
    #   иначе поворот невозможен
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
