module FirmwaresHelper
  def link_to_firmware(fw, options = {})
    text = options.delete(:text) || "#{h fw.name}"
    link_to text, firmware_path(fw), options
  end

  def link_to_firmware_version(fwv, options = {})
    no_version = options.delete :no_version
    fw = fwv.firmware
    version = no_version ? "" : " версии #{fwv.number}"
    text = options.delete(:text) || %Q{"#{h fw.name}"#{version}}
    link_to text, firmware_version_path( :id => fw, :number => fwv.number ), options
  end

  def format_code(code)
    code = h code
    code = code.gsub /\r\n/, "\n"
    code = code.gsub /(#.+)$/, '<i>\1</i>'
    code = code.gsub /(?:^|\b)(if|else|end|while|def|return|and|or|not)\b/, '<strong>\1</strong>'
    code = code.gsub /(^|\s)(@log)\b/, '\1<strong>\2</strong>'
  end

  def syntax_errors_list_for(fwv)
    if current_user.owns? fwv.firmware
      render :partial => 'syntax_error', :collection => fwv.syntax_errors
    end
  end

  def can_see_code_of?(fw)
    current_user.owns?(fw) || fw.shared?
  end

  def can_fight_with?(fw)
    current_user.owns?(fw) || fw.available?
  end

  def format_firmware_version_short_message(fwv)
    number_part = "##{fwv.number}"
    first_line = (fwv.message || "").lines.first
    message_part = first_line.blank? ? "" : ": " + h(first_line.chomp)
    number_part + message_part
  end

  def format_firmware_version_message(fwv)
    simple_format( fwv.message.blank? ? "(отсутствует)" : h(fwv.message) )
  end

  def link_to_firmware_version_with_message(fwv)
    link_to_firmware_version fwv, :text => format_firmware_version_short_message(fwv)
  end

  def actions_for_firmware(fw)
    action "Прошивка", firmware_path(fw)
    action "Редактировать", edit_firmware_path(fw) if current_user.owns? fw
    action "История версий", firmware_versions_path(fw)

    link "Сразиться!", new_match_path(:enemy_fw => fw) if can_fight_with? fw
    link "Список матчей", firmware_matches_path(fw)
  end

  def actions_for_firmwares
    action "Ваши прошивки", firmwares_path
    action "Все прошивки", all_firmwares_path
    action "Новая прошивка", new_firmware_path
  end
end

