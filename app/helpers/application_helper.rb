module ApplicationHelper
  def format_datetime(time)
    Russian.strftime time, "%e %B %Y, %H:%M"
  end

  # Возвращает строку полученную преобразованием строки +format+ по следующим правилам:
  # * '%?' заменяется на число +number+
  # * '%{one,few,many,other}' заменяется на один из вариантов в соответствии с правилами руссками языка
  def pl(format, number)
    format.tap do |s|
      s.gsub! '%?', number.to_s
      s.gsub! /%\{[^}]+\}/ do |sub|
        variants = sub[2...-1].split(',', -1)
        Russian::pluralize number, *variants
      end
    end
  end

  def format_life_years(start_year)
    this_year = Time.now.year
    if this_year == start_year
      start_year.to_s
    else
      "#{start_year}‒#{this_year}"
    end
  end
end
