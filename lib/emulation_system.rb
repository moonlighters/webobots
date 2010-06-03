# == Система эмуляции
# Предоставляет функционал проверки синтаксиса исходного кода прошивок и
# эмуляции матчей
module EmulationSystem
  # Функция парсит исходный код и проверяет его на наличие
  # синтаксических ошибок
  def check_syntax_errors(code)
    Parsing::Parser.new(code).parse
    []
  rescue Errors::WFLSyntaxError => e
    e.errors
  end
  module_function :check_syntax_errors

  # Выполняет эмуляцию матча двух прошивок
  def emulate(code1, code2, params, logger)
    ir1 = Parsing::Parser.new(code1).parse
    ir2 = Parsing::Parser.new(code2).parse
    res = Emulation::VM.new(ir1, ir2, params, logger).emulate
    srand
    res
  end
  module_function :emulate

  # Сгенерировать случайные параметры для матча
  def generate_vm_params
    bots = 2.times.map do
      {
        :x => rand*Emulation::World::FIELD_SIZE,
        :y => rand*Emulation::World::FIELD_SIZE,
        :angle => rand*360
      }
    end
    {
      :first => bots.first,
      :second => bots.second,
      :seed => srand
    }
  end
  module_function :generate_vm_params
end
