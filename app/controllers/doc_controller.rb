class DocController < ApplicationController
  before_filter :require_user

  def tour
  end

  def tutorial
    @samples = {}
    @samples[:simple] = "set_speed(100)"
    @samples[:sample_program] = <<-SAMPLE1
set_speed(50)
while 1
  x = posx()
  y = posy()
  if x < 100
    rotate(45)
    @log "Бум!"
  end
  if x > 900
    rotate(-135)
    @log "Бац!"
  end
  if y < 100
    rotate(135)
    @log "Шлёп!"
  end
  if y > 900
    rotate(-45)
    @log "Дыщь!"
  end
end
    SAMPLE1
    @samples[:first_line] = "set_speed(50)"
    @samples[:while] = <<-SAMPLE3
while 1
  ...
end
    SAMPLE3
    @samples[:posx] = "x = posx()"
    @samples[:if] = <<-SAMPLE5
if x < 100
  ...
end
    SAMPLE5
    @samples[:rotate] = "rotate(45)"
    @samples[:log] = %q{@log "Бум!"}
    @samples[:logging_example] = %q{@log "x =", x, ", 2 + 2 =", 2 + 2}
  end

  def waffle_language
  end

  def runtime_library
  end
end
