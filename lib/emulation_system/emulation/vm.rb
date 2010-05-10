module EmulationSystem
  # Модуль эмуляции матчей
  module Emulation
    # Виртуальная машина, интерпретирующая матч между прошивками
    class VM
      # * <tt>ir1</tt>, <tt>ir2</tt> - IR двух прошивок
      # * +params+ - хеш содержащий позицию и угол ботов,
      #   а также seed для рандомизатора
      #       {
      #         :first => { :x => x1, :y => y1, :angle => angle1},
      #         :second => { :x => x2, :y => y2, :angle => angle2},
      #         :seed => some_seed
      #       }
      # * +logger+ - сохраняет информацию, получаемую через
      #   <tt>add_frame(bot1, bot2, env)</tt>, для создания повтора
      def initialize(ir1, ir2, params, logger)
        @seed = params[:seed]
        @logger = logger

        @bots = [
          BotContext.new(ir1,
            params[:first][:x],  params[:first][:y],  params[:first][:angle]),
          BotContext.new(ir2,
            params[:second][:x], params[:second][:y], params[:second][:angle])
        ]
      end
    
      # Производит эмуляцию матча
      #
      # Возвращает результат матча:
      # * <tt>:first</tt>
      # * <tt>:second</tt>
      # * <tt>:draw</tt>
      def emulate
      end
    end
  end
end
