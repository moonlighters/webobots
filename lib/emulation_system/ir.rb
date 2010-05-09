module EmulationSystem
  # Промежуточное представление (Intermediate Representation)
  # кода прошивки, используемое виртуальной машиной
  class IR
    attr_reader :root

    # Структура для хранения узла дерева IR
    # * +data+ - строка или число
    # * +children+ - список поддеревьев
    Node = Struct.new :data, :children

    # +root+ экземпляр класса Node
    def initialize(root)
      @root = root
    end
  end
end
