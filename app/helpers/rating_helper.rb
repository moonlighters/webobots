module RatingHelper
  def format_points(points)
    "%.1f" % points.to_f
  end
end
