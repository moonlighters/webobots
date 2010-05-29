module EmulationSystem
  # == Модуль эмуляции матчей
  module Emulation
    # === Виртуальная машина
    # Интерпретирует матч между прошивками
    class VM
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
      end
    
      # Производит эмуляцию матча
      #
      # Возвращает результат матча:
      # * <tt>:first</tt>
      # * <tt>:second</tt>
      # * <tt>:draw</tt>
      def emulate
        while not @bots.any?(&:halted?)
          @bots.each do |bot|
            bot.step
          end
        end

        if @bots.first.halted? and not @bots.second.halted?
          :second
        elsif not @bots.first.halted? and @bots.second.halted?
          :first
        else
          :draw
        end
      end
    end
  end
end
