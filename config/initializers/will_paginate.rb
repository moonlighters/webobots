[:previous_label, :next_label].each do |key|
  WillPaginate::ViewHelpers.pagination_options[key] = I18n.t "will_paginate.#{key}"
end
WillPaginate::ViewHelpers.pagination_options[:page_links] = false
