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

  # TODO: написать
  def emulate(code1, code2, params, logger)
    # TODO: придумать что делать с ошибками
    ir1 = Parsing::Parser.new(code1).parse
    ir2 = Parsing::Parser.new(code2).parse
    Emulation::VM.new(ir1, ir2, params, logger).emulate
  end
  module_function :emulate
end
