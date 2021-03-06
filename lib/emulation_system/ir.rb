module EmulationSystem
  # === Промежуточное представление
  # Представление кода прошивки, используемое виртуальной машиной
  # (Intermediate Representation)
  class IR
    attr_reader :root

    # === Узел дерева IR
    # * +data+ - строка или число
    # * +children+ - список поддеревьев
    class Node < Struct.new :data, :children
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
