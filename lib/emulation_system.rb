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
end
