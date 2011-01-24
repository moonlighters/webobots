class DocController < ApplicationController
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
    @samples = {}
    @samples[:hello_world] = %q{@log "Hello world!"}
    @samples[:numbers] = %q{3, 4.5, 0, 100.0}
    @samples[:comments] = <<-SAMPLE_COMMENTS
speed = 10
time = 1000 / speed   # total time
    SAMPLE_COMMENTS
    @samples[:operations] = <<-SAMPLE_OPERATIONS
a = 2
b = 3
c = 0

a + b     # 5
a * (-b)  # -6
a and c   # 0
a or c    # 1
not a     # 0
a > b     # 0
a < b     # 1
a >= a    # 1
b == c    # 0
a != b    # 1
    SAMPLE_OPERATIONS
    @samples[:log_speed] = %q{@log "My speed", speed()}
    @samples[:log_dummy] = %q{@log "2+3 =", 5}
    @samples[:if] = <<-SAMPLE_IF
if conditional_expression
  expr1
else
  expr2
end
    SAMPLE_IF
    @samples[:if_detailed] = <<-SAMPLE_IF_DETAILED
if 3 != 2
  @log "!="
else
  @log "=="
end

if 1
  # исполнение всегда пойдет сюда
  a = 2+3
  b = a*2
end

if (2*2 == 5)
  # исполнение никогда сюда не попадет
  a = 2/0
end
    SAMPLE_IF_DETAILED
    @samples[:while] = <<-WHILE
while conditional_expression
  expr
end
    WHILE
    @samples[:while_detailed] = <<-WHILE_DETAILED
i = 5
while i > 0
  @log i
  i = i - 1
end

while 1
  @log "Бесконечный цикл!"
end
    WHILE_DETAILED
    @samples[:functions] = <<-FUNCTIONS
def factorial(n)
  if n <= 1
    return 1
  end
  return n * factorial(n - 1)
end

a = factorial(1)  # 1
b = factorial(5)  # 120

def thirty_seven()
  return 37
end

c = thirty_seven()

def work_hard(times)
  if times < 0
    return
  end
  # work very hard
  # ...
end

work_hard(3)
    FUNCTIONS
  end

  def runtime_library
    @samples = {}
    @samples[:constants] = <<-SAMPLE
set_speed(50) # плохо
set_speed(MAX_SPEED_WHEN_ROTATION_POSSIBLE) # хорошо

if (pos < 30)
  # плохо
end
if (pos < BOT_RADIUS)
  # хорошо
end
    SAMPLE
  end
end
