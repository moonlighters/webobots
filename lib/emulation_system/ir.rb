module EmulationSystem
  # Промежуточное представление (Intermediate Representation)
  # кода прошивки, используемое виртуальной машиной
  class IR
    attr_reader :root

    # Структура для хранения узла дерева IR
    # * +data+ - строка или число
    # * +children+ - список поддеревьев
    Node = Struct.new :data, :children do
      # Наглядный вывод дерева в строку для отладки
      def to_s(shift = 0)
        buf = '| '*shift + self.data + "\n"
        buf += self.children.map { |n| n.to_s( shift+1 ) }.join
      end
    end

    # +root+ экземпляр класса Node
    def initialize(root)
      @root = root
    end
  end
end
