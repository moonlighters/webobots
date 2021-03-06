module FirmwaresHelper
  def link_to_firmware(fw, options = {})
    max_length = options.delete(:max_length) || 20
    text = options.delete(:text) || "#{cut_to_length h(fw.name), max_length}"
    link_to text, user_firmware_path(fw.user, fw), options
  end

  def link_to_firmware_version(fwv, options = {})
    max_length = options.delete(:max_length) || 20
    no_version = options.delete :no_version
    fw = fwv.firmware
    version = no_version ? "" : " ##{fwv.number}"
    text = options.delete(:text) || %Q{#{cut_to_length h(fw.name), max_length}#{version}}
    link_to text, user_firmware_version_path( :user_id => fw.user, :id => fw, :number => fwv.number ), options
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

  private
  def cut_to_length(s, max)
    (s.length > max) ? s.mb_chars[0...(max-1)] + '...' : s
  end
end

