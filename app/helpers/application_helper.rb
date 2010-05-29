module ApplicationHelper
  def format_datetime(time)
    Russian.strftime time, "%e %B %Y, %H:%M"
  end
end
