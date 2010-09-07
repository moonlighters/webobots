module RatingHelper
  def format_points(points)
    "%.1f" % points.to_f
  end

  def actions_for_rating
    action "Пользователи", users_rating_path
    action "Прошивки", firmwares_rating_path
  end
end
