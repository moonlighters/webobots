module EmulationSystem
  module Emulation

    # == Описание игрового мира
    # * поле имеет размеры 1000x1000 см2
    # * углы отсчитываются в градусах от оси X к оси Y
    # * единица времени — 1 с
    # * единица скорости — 1 см/с
    # * ограничена максимальная скорость — 100 см/с.
    # * здоровье бота изменяется от 0 до 100
    # * разгон и торможение происходят с фиксированными ускорениями
    # * ограничена маскимальная скорострельность — 1.5 выстрела/с
    # * поворот бота возможен на любой угол, если скорость меньше определенной,
    #   иначе поворот невозможен
    # * такт процессора — 2 мс
    # * ограничено время существования "мира" — 60 с
    # * бот — круг радиуса 30 см
    # * скорость ракеты 200 м/с
    # * радиус взрыва ракеты 50 см
    # * максимальный урон от ракеты 10 (при непосредственном столкновении),
    #   линейно падает до 0 (с увеличением расстояния от ракеты до окружности бота)
    module World
      FIELD_SIZE = 1000.0
      MAX_HEALTH = 100.0
      MAX_SPEED = 100.0
      ACCELERATION = 15.0
      DECELERATION = 30.0
      RATE_OF_FIRE = 1.5
      MAX_SPEED_WHEN_ROTATION_POSSIBLE = 50.0
      VM_TIME = 2e-3
      MAX_LIFE_TIME = 60.0
      BOT_RADIUS = 30.0
      MISSILE_SPEED = 200.0
      MISSILE_DAMAGE = 10.0
      EXPLOSION_RADIUS = 50.0
    end
  end
end
