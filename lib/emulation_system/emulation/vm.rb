module EmulationSystem
  # == Модуль эмуляции матчей
  module Emulation
    # === Виртуальная машина
    # Интерпретирует матч между прошивками
    class VM
      VERSION = '0.1.2'

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
      def emulate(max_life_time = World::MAX_LIFE_TIME)
        syncs = 0
        explosions = []
        while not @bots.any? &:dead?
          if syncs % FRAME_PERIOD_IN_SYNCS == 0
            @logger.add_frame @bots[0], @bots[1], {
              :missiles => @missiles,
              :explosions => explosions,
              :time => @time
            }
            explosions = []
          end

          @bots[0].calc_physics_for SYNC_PERIOD, @bots[1]
          @bots[1].calc_physics_for SYNC_PERIOD, @bots[0]

          @missiles.each do |missile|
            missile.calc_physics_for SYNC_PERIOD
            missile.explode! if @bots.any? { |bot| missile.hit? bot }
          end

          @missiles.select(&:exploded?).each do |missile|
            explosions << missile.pos
            @bots.each do |bot|
              missile.injure bot
            end
            @missiles.delete missile
          end

          @bots[0].step while @bots[0].time < @time and not @bots[0].halted?
          @bots[1].step while @bots[1].time < @time and not @bots[1].halted?

          @time += SYNC_PERIOD
          syncs += 1

          break if @time > max_life_time
        end

        case @bots.map &:dead?
        when [true, false]
          :second
        when [false, true]
          :first
        else
          if @bots.first.health > @bots.second.health
            :first
          elsif @bots.second.health > @bots.first.health
            :second
          else
            :draw
          end
        end
      end
    end
  end
end
