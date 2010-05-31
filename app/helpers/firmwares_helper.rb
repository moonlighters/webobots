module FirmwaresHelper
  def link_to_firmware(fw, parameters = {})
    text = parameters.delete(:text) || "#{h fw.name}"
    link_to text, firmware_path(fw), parameters
  end

  def link_to_firmware_version(fwv)
    fw = fwv.firmware
    link_to %Q{"#{h fw.name}" версии #{fwv.number}}, firmware_version_path( :id => fw, :number => fwv.number )
  end

  def format_code(code)
    code = code.gsub /(#.+)$/, '<i>\1</i>'
    code = code.gsub /(?:^|\b)(if|else|end|while|def|return|and|or|not)\b/, '<strong>\1</strong>'
    code = code.gsub /(^|\s)(@log)\b/, '\1<strong>\2</strong>'
  end

  def syntax_errors_list_for(fwv)
    if current_user.owns? fwv.firmware
      render :partial => 'syntax_error', :collection => fwv.syntax_errors
    end
  end
end
