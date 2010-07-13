module EmulationSystem
  module Emulation
    class Bot
      # === Состояние бота
      # * +pos+ - позиция бота на поле
      # * +angle+ - направление движения бота
      # * +speed+ - модуль мгновенной скорости
      # * +desired_speed+ - конечное значение модуля скорости при разгоне и торможении
      # * +health+ - здоровье
      class State < Struct.new :pos, :angle, :speed, :desired_speed, :health
        def radians
          angle * Math::PI / 180
        end
        
        def radians=(value)
          self.angle = value / Math::PI * 180
        end

        def cosa
          Math::cos(radians)
        end

        def sina
          Math::sin(radians)
        end

        # Возвращает режим движения:
        # * +accelerated+ - разгоняется
        # * +decelerated+ - тормозит
        # * +uniform+     - равномерное движение
        def speed_mode
          if speed > desired_speed
            :decelerated
          elsif speed < desired_speed
            :accelerated
          else
            :uniform
          end
        end

        # Корректирует значения координат, скорости и здоровья
        # если они выходят за пределы
        def correct
          self.pos.x  = correct_value pos.x,  World::BOT_RADIUS, World::FIELD_SIZE - World::BOT_RADIUS
          self.pos.y  = correct_value pos.y,  World::BOT_RADIUS, World::FIELD_SIZE - World::BOT_RADIUS
          self.speed  = correct_value speed,  0, World::MAX_SPEED
          self.health = correct_value health, 0, World::MAX_HEALTH
        end

        # Возвращает значение +val+, ограниченное
        # до пределов +min+..+max+
        def correct_value(val, min, max)
          val < min ? min : (val > max ? max : val)
        end
      end
    end
  end
end
