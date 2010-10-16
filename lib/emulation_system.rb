# == Система эмуляции
# Предоставляет функционал проверки синтаксиса исходного кода прошивок и
# эмуляции матчей
module EmulationSystem
  # Функция парсит исходный код и возвращает массив синтаксических ошибок,
  # если их нет, то массив пустой
  def syntax_errors(code)
    Parsing::Parser.new(code).parse
    []
  rescue Errors::WFLSyntaxError => e
    e.errors
  end
  module_function :syntax_errors

  # Выполняет эмуляцию матча двух прошивок, синтаксически корректных
  #
  # Возвращает хэш в зависимости от успеха эмуляции:
  # * <tt>{:result => :first/:second/:draw}</tt>
  # * <tt>{:error => {:bot => :first/:second, :message => "..."}}</tt>
  def emulate(code1, code2, params, logger)
    begin
      ir1 = Parsing::Parser.new(code1).parse
      ir2 = Parsing::Parser.new(code2).parse
    rescue Errors::WFLSyntaxError => e
      raise "Внутренняя ошибка эмуляции: прошивки содержат синтаксические ошибки"
    end

    begin
      res = Emulation::VM.new(ir1, ir2, params, logger).emulate
      srand
      {:result => res}
    rescue Errors::WFLRuntimeError => e
      bot = case e.index
            when 0 then :first
            when 1 then :second
            end
      {:error => {:bot => bot, :message => e.message}}
    end
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
