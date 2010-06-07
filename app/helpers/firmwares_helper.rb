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
end
