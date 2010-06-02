module EmulationSystem::Emulation
  # == Хранит информацию об условной длительности выполнения элементов языка
  module Timing
    include RuntimeElements

    def for(elem, action = nil)
      World::VM_TIME *  if elem == :rt
                          rt_times(action)
                        else
                          TIMES[elem.is_a?(Class) ? elem : elem.class][action || :default]
                        end
    end
    module_function :for

    private
    # TODO: раскидать времена
    # и не забыть про бесконечные циклы, которые не тратят время!
    TIMES = {
      Block => {
        :step => 0,
        :finish => 1
      },
      Assignment => {
        :evaluation => 0,
        :assignment => 1
      },
      Literal => {
        :default => 0
      },
      If => {
        :evaluation => 0,
        :finish => 1
      },
      While => {
        :evaluation => 0,
        :execution => 1
      },
      Variable => {
        :default => 1
      },
      BinaryOp => {
        :evaluation => 0,
        :calculation_sum => 5,
        :calculation_mult => 10,
        :calculation_cmp => 5,
        :calculation_logical => 3
      },
      UnaryOp => {
        :evaluation => 0,
        :calculation_umath => 1,
        :calculation_logical => 1
      },
      FuncDef => {
        :default => 1
      },
      FuncCall => {
        :evaluation => 0,
        :calling => 5
      },
      Return => {
        :evaluation => 0,
        :cleaning => 3
      },
      Log => {
        :evaluation => 0,
        :logging => 5
      },
    }

    def rt_times(func)
      case func
      when  'posx', 'posy', 'angle', 'speed',
            'desired_speed', 'health', 'time'
        8

      when 'rotate','set_speed'
        13

      when 'sleep'
        5

      when 'enemy_posx','enemy_posy'
        20

      when 'fire'
        16

      when 'sin','cos','atan2','sqr','sqrt'
        10

      when 'rand'
        10

      end
    end
    module_function :rt_times
  end
end
