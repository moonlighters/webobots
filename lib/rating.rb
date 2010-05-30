# == Система рейтинга
# Позволяет расчитать очки рейтинга, получаемые участниками конкретного матча
module Rating

  # Константы для определения очков победителя
  module Winner
    # Очки, который победитель получает всегда
    ALWAYS = 5

    # Дополнительные очки, которые победитель получает,
    # побеждая кого-то такого же уровня, как он
    WITH_SAME = 15

    # Коэффициент линейной зависимости дополнительных очков
    # от разности, когда победитель имеет меньший рейтинг
    RISE_COEFF = 4

    # Максимальное превосходство победителя над проигравшим по очкам
    # при котором победитель ещё получает дополнительные очки
    MAX_NEGATIVE_DIFF = 20
    
    # Коэффициент экспоненциального спада, вычисляемый так,
    # чтобы удовлетворить условию на MAX_NEGATIVE_DIFF
    FALL_COEFF = Math.log(WITH_SAME)/MAX_NEGATIVE_DIFF
  end

  # Константы для определения очков проигравшего
  module Loser
    ALWAYS = 0
    WITH_SAME = 0
  end

  # Возвращает [points_for_winner, points_for_loser]
  def points_for(winner_points, loser_points)
    # очки победителя
    points_for_winner = Winner::ALWAYS
    
    # победитель получает больше, когда у проигравшего рейтинг выше!
    diff = (loser_points - winner_points).to_f
    if diff < 0
      addition = Winner::WITH_SAME*Math.exp( diff*Winner::FALL_COEFF )
      addition = 0.0 if addition < 1
      points_for_winner += addition
    else
      points_for_winner += Winner::WITH_SAME + diff/Winner::RISE_COEFF
    end
    
    [points_for_winner, 0]
  end

  module_function :points_for
end
