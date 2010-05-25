module FirmwaresHelper
  def link_to_firmware(fw)
    link_to "#{h fw.name} ##{fw.versions.last_number}", firmware_path(fw)
  end

  def format_code(code)
    highlight( code.gsub( /\n/, "<br/>\n" ),
               %w{if else end while},
               :highlighter => '<strong>\1</strong>' )
  end

  def syntax_errors_list_for(fw)
    if current_user.owns? fw and not fw.syntax_errors.empty?
      render :partial => 'syntax_error', :collection => fw.syntax_errors
    end
  end
end
