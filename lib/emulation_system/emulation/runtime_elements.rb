module EmulationSystem
 module Emulation
  # == Модуль, содержащий классы элементов языка
  #
  # В нем объявлены классы, реализующие семантику языка WaFfLe.
  #
  # Классы реализуют методы <tt>new(bot, node)</tt> и <tt>run</tt>
  module RuntimeElements
    # Шаблон для остальных классов +RuntimeElements+
    #
    # === Класс для элемента ELEMENT
    # <tt>NODE["element"]</tt>
    # class Nop
    #   def initialize(bot, node)
    #     @bot = bot
    #   end
    #
    #   def run
    #     Timing.for self
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
          Timing.for self, :step
        else
          # мы обязаны делать pop только после (!)всех(!) детей
          @bot.pop_element
          Timing.for self, :finish
        end
      end

      def set_variable(id, value)
        @variables[id] = value
      end

      def get_variable(id)
        if @upper_block
          @variables[id] || @upper_block.get_variable(id)
        else
          @variables[id] or raise Errors::WFLRuntimeError, "неизвестный идентификатор '#{id}'"
        end
      end
    end

    # === Класс для элемента =
    # <tt>^('=' ID expr)</tt>
    class Assignment
      def initialize(bot, node)
        @bot = bot
        @id, @expr = node.children

        @expr_evaluated = false
      end

      def run
        unless @expr_evaluated
          @bot.push_element @expr
          @expr_evaluated = true
          Timing.for self, :evaluation
        else
          @bot.upper_block_from(self).set_variable @id.data, @bot.pop_var
          @bot.pop_element
          Timing.for self, :assignment
        end
      end
    end

    # === Класс для элементов NUMBER
    # <tt>NUMBER</tt>
    class Number
      def initialize(bot, node)
        @bot = bot
        
        @value = node
      end

      def run
        @bot.pop_element
        var = if @value.data =~ /^\d+$/
                @value.data.to_i
              else
                @value.data.to_f
              end
        @bot.push_var var
        Timing.for self
      end
    end
   
    # === Класс для элемента if
    # <tt>^('if' expr $ifblock $elseblock?)</tt>
    class If
      def initialize(bot, node)
        @bot = bot
        @expr, @then, @else = node.children

        @expr_evaluated = false
      end
    
      def run
        unless @expr_evaluated
          @bot.push_element @expr
          @expr_evaluated = true
          Timing.for self, :evaluation
        else
          @bot.pop_element
          if @bot.pop_var != 0
            @bot.push_element @then
          elsif @else != nil
            @bot.push_element @else
          end
          Timing.for self, :finish
        end
      end
    end

    # === Класс для элемента id
    # <tt>^(NODE["id"] ID)</tt>
    class Identifier
      def initialize(bot, node)
        @bot = bot
        @id = node.children.first
      end
    
      def run
        var = @bot.upper_block_from(self).get_variable @id.data
        @bot.pop_element
        @bot.push_var var
        Timing.for self
      end
    end
  end
 end
end
