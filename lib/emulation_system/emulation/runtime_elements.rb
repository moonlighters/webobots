# == Модуль, содержащий классы элементов языка
#
# В нем объявлены классы, реализующие семантику языка WaFfLe.
#
# Классы реализуют методы <tt>new(bot, node)</tt> и <tt>run</tt>
module EmulationSystem::Emulation::RuntimeElements
  # === Шаблон для остальных классов +RuntimeElements+
  # class Nop
  #   def initialize(bot, node)
  #     @bot = bot
  #   end
  #
  #   def run
  #     true
  #   end
  # end

  # === Класс для элемента block
  # <tt>^(NODE["block"] stat*)</tt>
  class Block
    def initialize(bot, node)
      @bot = bot

      @children = node.children
      @next_child = 0

      @upper_block = @bot.upper_block_from self

      @variables = {}
      @functions = {}
    end

    def run
      if @next_child < @children.count
        @bot.push_element @children[@next_child]
        @next_child += 1
      else
        @bot.pop_element
      end
    end

    def set_variable(id, var)
      @variables[id] = var
    end
  end

  # === Класс для элемента =
  # <tt>^('=' ID expr)</tt>
  class Assignment
    def initialize(bot, node)
      @bot = bot
      @id = node.children.first.data
      @expr_node = node.children.second

      @expr_evaluated = false
    end

    def run
      unless @expr_evaluated
        @bot.push_element @expr_node
        @expr_evaluated = true
      else
        @bot.upper_block_from(self).set_variable @id, @bot.pop_var
        @bot.pop_element
      end
    end
  end

  # === Класс для элементов NUMBER
  # <tt>NUMBER</tt>
  class Number
    def initialize(bot, node)
      @bot = bot
      
      @value = if node.data =~ /^\d+$/
                 node.data.to_i
               else
                 node.data.to_f
               end
    end

    def run
      @bot.pop_element
      @bot.push_var @value
    end
  end
end
