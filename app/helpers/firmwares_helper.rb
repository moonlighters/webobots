module FirmwaresHelper
  def link_to_firmware(fw, parameters = {})
    no_version = parameters.delete :no_version
    version =  no_version ? "" : " (версия ##{fw.versions.last_number})"
    link_to "#{h fw.name}"+version, firmware_path(fw), parameters
  end

  def link_to_firmware_version(fwv)
   link_to_firmware(fwv.firmware, :no_version => true) +
     " версии " +
     fwv.number.to_s
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
