module FirmwaresHelper
  def link_to_firmware(fw, parameters = {})
    no_version = parameters.delete :no_version
    version =  no_version ? "" : " (версия ##{fw.versions.last_number})"

    text = parameters.delete(:text) || "#{h fw.name}"+version
    link_to text, firmware_path(fw), parameters
  end

  def link_to_firmware_version(fwv)
    fw = fwv.firmware
    link_to %Q{"#{fw.name}" версии #{fwv.number}}, show_firmware_version_path( fw.id, fwv.number )
  end

  def format_code(code)
    code.gsub(
      /(#.+)$/,
      '<i>\1</i>').gsub(
        /(?:^|\b)(if|else|end|while|def|return|@log)\b/,
        '<strong>\1</strong>')
  end

  def syntax_errors_list_for(fw)
    if current_user.owns? fw and not fw.syntax_errors.empty?
      render :partial => 'syntax_error', :collection => fw.syntax_errors
    end
  end
end
