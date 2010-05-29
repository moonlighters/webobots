module EmulationSystem
  # == Парсинг исходного кода
  module Parsing
    # === Парсер
    # Делегирует функцию парсинга исходного кода внешнему парсеру и
    # полученое дерево преобразует в IR
    class Parser
      LP,RP = '(', ')' # :nodoc:
      
      # +code+ - исходный код прошивки
      # +parser+ - класс, реализующий вызов внешнего парсера
      def initialize(code, parser = ANTLRParser)
        @code = code
        @external_parser = parser
      end

      # Парсит и возвращает экземляр IR
      # ( TODO а что делать с ошибками? )
      def parse
        res = @external_parser.call @code
        transform_to_ir res
      end

      private

      # Конвертирует Lisp нотацию в дерево для IR
      def transform_to_ir(text)
        # разбивает строку на токены по пробельным символам и скобкам,
        # при этом сохраняя скобки
        @tokens = text.split( /([\s#{LP}#{RP}])/ ).reject(&:blank?)
        # текущий токен
        @cur = 0

        # рекурсивный поиск
        root = detect_node
        if @cur != @tokens.count
          raise "Внутренняя ошибка парсера Lisp-нотации: неожиданные символы в конце"
        end
        IR.new root
      end

      # Текущий токен
      def get
        if @cur >= @tokens.count
          raise "Внутренняя ошибка парсера Lisp-нотации: неожиданный конец"
        end
        @tokens[@cur]
      end
      # Следующий токен
      def inc; @cur += 1; end

      # Рекурсивная функция поиска узла дерева в +@tokens+,
      # начиная с позиции +@cur+
      def detect_node
        node = IR::Node[ "", [] ]
        if get != LP
          # единичный узел
          node.data = get
          inc
        else
          # а это целое поддерево
          inc
          node.data = get
          inc
          while get != RP
            node.children << detect_node
          end
          inc
        end
        node
      end
    end
  end
end
