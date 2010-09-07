module LayoutHelper
  def title(title = nil)
    @title = title
  end

  def actions(*actions)
    @actions = actions
  end

  def action(*action)
    @actions ||= []
    @actions << action
  end

  def links(*links)
    @links = links
  end

  def link(*link)
    @links ||= []
    @links << link
  end

  def has_actions_or_links?
    not (@actions.blank? and @links.blank?)
  end

  def has_both_actions_and_links?
    not (@actions.blank? or @links.blank?)
  end

  def list_items(array) # :nodoc:
    return if array.blank?
    ( array.compact.map { |item| content_tag :li, link_to( *item ) } ) * "\n"
  end

  def actions_list
    list_items(@actions)
  end

  def links_list
    list_items(@links)
  end

  def flash_sections
    %w(alert notice).map { |sec| flash_section(sec) } * "\n"
  end

  def flash_section(sec)
    text = flash[sec.to_sym]
    div_options = {
      :class => "flash-messages #{sec}",
      :id => "flash-#{sec}"
    }

    if text
      text = content_tag :p, h(text)
    else
      div_options.merge! :style => "display:none;"
    end

    content_tag :div, text, div_options
  end
end
