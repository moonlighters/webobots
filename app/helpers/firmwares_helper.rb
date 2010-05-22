module FirmwaresHelper
  def link_to_firmware(fw)
    link_to "#{h fw.name} ##{fw.versions.last_number}", firmware_path(fw)
  end

  def format_code(code)
    highlight( code.gsub( /\n/, "<br/>\n" ),
               %w{if else end while},
               :highlighter => '<strong>\1</strong>' )
  end
end
