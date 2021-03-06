module LayoutHelper
  def title(title = nil)
    @title = title
  end

  def flash_sections
    %w(alert notice).map { |sec| flash_section(sec) } * "\n"
  end

  def flash_section(sec)
    text = flash[sec.to_sym]
    div_options = {
      :class => "flash_messages #{sec}",
      :id => "flash_#{sec}"
    }

    if text
      text = content_tag :p, h(text)
    else
      div_options.merge! :style => "display:none;"
    end

    content_tag :div, text, div_options
  end
end
