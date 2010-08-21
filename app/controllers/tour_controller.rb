class TourController < ApplicationController
  def show
    @samples = []
    @samples[0] = "set_speed(100)"
    @samples[1] = <<-SAMPLE1
set_speed(50)
while 1
  x = posx()
  y = posy()
  if x < 100
    rotate(45)
  end
  if x > 900
    rotate(-135)
  end
  if y < 100
    rotate(135)
  end
  if y > 900
    rotate(-45)
  end
end
    SAMPLE1
    @samples[2] = "set_speed(50)"
    @samples[3] = <<-SAMPLE3
while 1
  ...
end
    SAMPLE3
    @samples[4] = "x = posx()"
    @samples[5] = <<-SAMPLE5
if x < 100
  ...
end
    SAMPLE5
    @samples[6] = "rotate(45)"
  end
end
