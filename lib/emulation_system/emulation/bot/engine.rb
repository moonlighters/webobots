module EmulationSystem
  module Emulation
    class Bot
      # === Модуль отвечающий за физику бота
      module Engine
        attr_reader :state

        # Жив ли?
        def dead?
          @state.health <= 0
        end

        # Возвращает положение бота
        def pos
          @state.pos
        end

        # Возвращает здоровье бота
        def health
          @state.health
        end

        # Снимает определенное количество здоровья
        def injure!(x)
          @state.health -= x
        end

        # Просчитывает шаг физики за время dt
        def calc_physics_for(dt, other_bot=nil)
          if @state.speed_mode == :accelerated
            @state.speed += World::ACCELERATION*dt
            @state.speed = @state.desired_speed if @state.speed_mode == :decelerated
          elsif @state.speed_mode == :decelerated
            @state.speed -= World::DECELERATION*dt
            @state.speed = @state.desired_speed if @state.speed_mode == :accelerated
          end

          @state.pos += Vector[@state.cosa, @state.sina]*@state.speed*dt

          collide_with other_bot unless other_bot.nil?
          @state.correct
        end

        protected

        def initialize_engine(x, y, angle)
          @state = State.new Point[x,y], angle
        end

        # Проверяет бота на столкновение с другими ботами и
        # при необходимости корректирует его положение
        def collide_with(bot)
          dist = @state.pos - bot.state.pos
          if dist.abs < 2*World::BOT_RADIUS
            # вытолкнуть наружу: двойной радиус на нормированное направление
            # (если боты в одной точке - выбираем случайное направление)
            direction = if dist.abs == 0
                          a = Kernel::rand()*Math::PI
                          Vector[Math::cos(a), Math::sin(a)]
                        else
                          dist/dist.abs
                        end
            @state.pos = bot.state.pos + direction * 2*World::BOT_RADIUS
          end
        end
      end
    end
  end
end
