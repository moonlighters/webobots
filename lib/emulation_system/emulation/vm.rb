module EmulationSystem
  # == Модуль эмуляции матчей
  module Emulation
    # === Виртуальная машина
    # Интерпретирует матч между прошивками
    class VM
      # Каждые SYNC_PERIOD секунд происходит просчет физического мира,
      # и синхронизация ботов
      SYNC_PERIOD = World::VM_TIME/2

      # * <tt>ir1</tt>, <tt>ir2</tt> - IR двух прошивок
      # * +params+ - хеш содержащий позицию и угол ботов,
      #   а также seed для рандомизатора
      #       {
      #         :first => { :x => x1, :y => y1, :angle => angle1},
      #         :second => { :x => x2, :y => y2, :angle => angle2},
      #         :seed => some_seed
      #       }
      # * +logger+ - сохраняет информацию, для создания повтора.
      #   Реализует метод <tt>add_frame(bot1, bot2, env)</tt> и
      #   <tt>add_log_record(bot, str)</tt>
      def initialize(ir1, ir2, params, logger)
        @seed = params[:seed]
        @logger = logger

        @bots = [
          Bot.new(ir1,
            params[:first][:x],  params[:first][:y],  params[:first][:angle],
            lambda {|str| @logger.add_log_record(:first, str) }),
          Bot.new(ir2,
            params[:second][:x], params[:second][:y], params[:second][:angle],
            lambda {|str| @logger.add_log_record(:second, str) })
        ]

        @time = 0
      end
    
      # Производит эмуляцию матча
      #
      # Возвращает результат матча:
      # * <tt>:first</tt>
      # * <tt>:second</tt>
      # * <tt>:draw</tt>
      def emulate
        while not @bots.any? &:halted?
          # calc physics
          # calc bot's health
          # calc missiles positions
          # ....

          @bots.each {|bot| bot.step while bot.time < @time and not bot.halted? }
          
          @time += SYNC_PERIOD

          break if @time > World::MAX_LIFE_TIME
        end

        case @bots.map &:halted?
        when [true, false]
          :second
        when [false, true]
          :first
        else
          :draw
        end
      end
    end
  end
end
