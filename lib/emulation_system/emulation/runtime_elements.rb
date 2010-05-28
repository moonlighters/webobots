module EmulationSystem
  module Emulation
    # == Модуль, содержащий классы элементов языка
    #
    # В нем объявлены классы, реализующие семантику языка WaFfLe.
    #
    # Классы реализуют методы <tt>new(bot, node)</tt> и <tt>run</tt>
    module RuntimeElements
      # === Класс для элемента block
      # <tt>^(NODE["block"] stat*)</tt>
      class Block
        # === Хранит информацию об объявленной функции
        class Func
          attr_reader :block

          def initialize(id, param_names, block)
            @id = id
            @param_names = param_names
            @block = block
          end

          # Принимает +params+ - массив значений параметров функции.
          # Возвращает хэш вида:
          #     {
          #       'param1' => params[0],
          #       'param2' => params[1]
          #     }
          # Если количество данных значений не совпадает с количеством параметров
          # функции, то кидается исключение
          def variables_hash_for(params)
            if @param_names.count != params.count
              raise Errors::WFLRuntimeError,
                "неверное количество аргументов (#{params.count} вместо #{@param_names.count}) для функции '#{@id}'"
            end
            hash = {}
            params.each_index do |i|
              hash[@param_names[i]] = params[i]
            end
            hash
          end
        end

        def initialize(bot, node, options={})
          @bot = bot
          @children = node.children
          @next_child = 0

          @upper_block = @bot.upper_block_from self

          @variables = {}
          # функции объявляются только в глобальном блоке
          @functions = {} if global?

          @function = options.delete(:function) || false
          (options.delete(:params) || {}).each {|id, value| set_variable id, value }
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

        def global?
          @upper_block.nil?
        end

        def function?
          @function
        end

        def set_variable(id, value)
          @variables[id] = value
        end

        def get_variable(id)
          if global?
            @variables[id] or raise Errors::WFLRuntimeError, "неизвестная переменная '#{id}'"
          else
            @variables[id] || @upper_block.get_variable(id)
          end
        end

        def set_function(id, params, block)
          unless global?
            raise Errors::WFLRuntimeError,
              "объявление функции '#{id}' не может находится внутри if,while или другой функции"
          end
          unless @functions.has_key? id
            @functions[id] = Func.new(id, params, block)
          else
            raise Errors::WFLRuntimeError,
              "функция с именем '#{id}' уже объявлена"
          end
        end

        def get_function(id)
          if global?
            @functions[id] or raise Errors::WFLRuntimeError, "неизвестная функция '#{id}'"
          else
            @upper_block.get_function(id)
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
      # <tt>^(NODE["var"] ID)</tt>
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

      # === Класс для элементов бинарных операций
      # <tt>^(OP expr expr)</tt>
      # Операции: +,-,*,/,>,>=,<,<=,==,!=
      class BinaryOp
        def initialize(bot, node)
          @bot = bot
          @op = node
          @exprL, @exprR = node.children

          @exprL_evaluated = false
          @exprR_evaluated = false
        end
      
        def run
          if !@exprL_evaluated
            @bot.push_element @exprL
            @exprL_evaluated = true
            Timing.for self, :evaluation

          elsif @exprL_evaluated && !@exprR_evaluated
            @varL = @bot.pop_var

            @bot.push_element @exprR
            @exprR_evaluated = true
            Timing.for self, :evaluation

          else # exprL and exprR are evaluated
            @varR = @bot.pop_var
            @bot.pop_element

            # hack for division
            if @op.data == '/'
              @varL = @varL.to_f 
              raise Errors::WFLRuntimeError, "деление на ноль" if @varR == 0
            end
            
            # real calculation
            res = case @op.data
                  when '!='
                    @varL != @varR
                  when 'and'
                    (@varL != 0) && (@varR != 0)
                  when 'or'
                    (@varL != 0) || (@varR != 0)
                  else
                    @varL.send(@op.data, @varR)
                  end

            # hack for booleans as 1 and 0
            # cmps and logical return +true+ and +false+
            if res == true
              res = 1
            elsif res == false
              res = 0
            end

            @bot.push_var res

            case @op.data
            when /^[-+]$/
              Timing.for self, :calculation_sum
            when /^[*\/]$/
              Timing.for self, :calculation_mult
            when /^(?:[<>]=?|[!=]=)$/
              Timing.for self, :calculation_cmp
            when /^(?:and|or)$/
              Timing.for self, :calculation_logical
            end
          end
        end
      end

      # === Класс для элементов унарных операций
      # <tt>^(OP expr)</tt>
      # Операции: uminus, uplus, not
      class UnaryOp
        def initialize(bot, node)
          @bot = bot
          @op = node
          @expr = node.children.first

          @expr_evaluated = false
        end
      
        def run
          unless @expr_evaluated
            @bot.push_element @expr
            @expr_evaluated = true
            Timing.for self, :evaluation
          else
            var = @bot.pop_var
            @bot.pop_element

            # real calculation
            res = case @op.data
                  when 'uminus'
                    - var
                  when 'uplus'
                    var
                  when 'not'
                    ! (var != 0)
                  end

            # hack for booleans as 1 and 0
            # cmp OPs return +true+ and +false+
            if res == true
              res = 1
            elsif res == false
              res = 0
            end

            @bot.push_var res

            case @op.data
            when /^(?:uminus|uplus)$/
              Timing.for self, :calculation_umath
            when /^not$/
              Timing.for self, :calculation_logical
            end
          end
        end
      end
 
      # === Класс для элемента funcdef
      # <tt>^(NODE["funcdef"] $name ^(NODE["params"] $p*) block)</tt>
      class FuncDef
        def initialize(bot, node)
          @bot = bot
          @id, @params, @block = node.children
        end

        def run
          @bot.upper_block_from(self).set_function( @id.data, @params.children.map(&:data), @block )
          @bot.pop_element
          Timing.for self
        end
      end
 
      # === Класс для элемента funccall
      # <tt>^(NODE["funccall"] ID ^(NODE["params"] $arg*))</tt>
      class FuncCall
        def initialize(bot, node)
          @bot = bot
          @id, @params = node.children
          @next_param = 0
          @evaluated_params = []
        end

        def run
          @evaluated_params << @bot.pop_var if @next_param > 0

          if @next_param < @params.children.count 
            @bot.push_element @params.children[@next_param]
            @next_param += 1
            Timing.for self, :evaluation
          else
            # OPTIMIZE: количество параметров можно проверить при первом же запуске
            func = @bot.upper_block_from(self).get_function( @id.data )
            @bot.pop_element

            params = func.variables_hash_for @evaluated_params
            @bot.push_element func.block, :function => true, :params => params
            Timing.for self, :calling
          end
        end
      end
 
      # === Класс для элемента return
      # <tt>'return'^ expr?</tt>
      class Return
        def initialize(bot, node)
          @bot = bot
          @expr = node.children.first
          @expr_evaluated = false
        end

        def run
          if @expr != nil and not @expr_evaluated
            @bot.push_element @expr
            @expr_evaluated = true
            Timing.for self, :evaluation
          else
            # нужное возращаемое значение уже на стеке
            func_block = @bot.upper_block_from( self, true ) or raise Errors::WFLRuntimeError,
              "недопустимо использование 'return' вне функции"

            loop { break if @bot.pop_element == func_block }

            Timing.for self, :cleaning
          end
        end
      end

      # === Класс для элемента @log
      # <tt>^(NODE["log"] $i*)</tt>
      class Log
        def initialize(bot, node)
          @bot = bot
          @items = node.children
          @next_item = 0
          @evaluated_items = []
        end

        def run
          @evaluated_items << @bot.pop_var if @next_item > 0

          if @next_item < @items.count 
            @bot.push_element @items[@next_item]
            @next_item += 1
            Timing.for self, :evaluation
          else
            @bot.pop_element
            @bot.log( @evaluated_items.map(&:to_s) * ' ' )
            Timing.for self, :logging
          end
        end
      end
 
    end
  end
end
