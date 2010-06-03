module EmulationSystem
  # == Модуль эмуляции матчей
  module Emulation
    # === Виртуальная машина
    # Интерпретирует матч между прошивками
    class VM
      # Каждые SYNC_PERIOD секунд происходит просчет физического мира,
      # и синхронизация ботов
      SYNC_PERIOD = World::VM_TIME/2
      FRAME_RATE = 10
      FRAME_PERIOD_IN_SYNCS = 1.0/FRAME_RATE/SYNC_PERIOD

      # * <tt>ir1</tt>, <tt>ir2</tt> - IR двух прошивок
      # * +params+ - хеш содержащий позицию и угол ботов,
      #   а также seed для рандомизатора
      #       {
      #         :first => { :x => x1, :y => y1, :angle => angle1},
      #         :second => { :x => x2, :y => y2, :angle => angle2},
      #         :seed => some_seed
      #       }
      # * +logger+ - класс из модуля +Loggers+,
      #   сохраняет информацию о прохождении матча
      def initialize(ir1, ir2, params, logger)
        @logger = logger

        @bots = [
          Bot.new(ir1,
            params[:first][:x],  params[:first][:y],  params[:first][:angle],
            lambda {|str| @logger.add_log_record(:first, str) }),
          Bot.new(ir2,
            params[:second][:x], params[:second][:y], params[:second][:angle],
            lambda {|str| @logger.add_log_record(:second, str) })
        ]
        @bots.each do |bot|
          bot.rtlib = RTLib.new :for => bot, :against => (@bots-[bot])[0], :vm => self
        end

        @time = 0
        @missiles = []

        srand params[:seed]
      end

      def launch_missile(*args)
        @missiles << Missile.new(*args)
      end
    
      # Производит эмуляцию матча
      #
      # Возвращает результат матча:
      # * <tt>:first</tt>
      # * <tt>:second</tt>
      # * <tt>:draw</tt>
      def emulate
        syncs = 0
        explosions = []
        while not @bots.any? &:halted?
          if syncs % FRAME_PERIOD_IN_SYNCS == 0
            @logger.add_frame @bots[0], @bots[1], {
              :missiles => @missiles,
              :explosions => explosions,
              :time => @time
            }
            explosions = []
          end

          @bots.each { |bot| bot.state.calc_physics_for SYNC_PERIOD }
          
          @missiles.each do |missile| 
            missile.calc_physics_for SYNC_PERIOD
            missile.explode! if @bots.any? { |bot| missile.pos.near_to? bot.state.pos, World::BOT_RADIUS }
          end

          @missiles.select(&:exploded?).each do |missile|
            explosions << missile.pos
            @bots.each do |bot|
              bot.state.health -= World::MISSILE_DAMAGE if missile.pos.near_to? bot.state.pos, World::EXLOSION_RADIUS
            end
            @missiles.delete missile
          end

          @bots.each { |bot| bot.step while bot.time < @time and not bot.halted? }
          
          @time += SYNC_PERIOD
          syncs += 1

          break if @time > World::MAX_LIFE_TIME
        end

        case @bots.map &:halted?
        when [true, false]
          :second
        when [false, true]
          :first
        else
          if @bots.first.state.health > @bots.second.state.health
            :first
          elsif @bots.second.state.health > @bots.first.state.health
            :second
          else
            :draw
          end
        end
      end
    end
  end
end
