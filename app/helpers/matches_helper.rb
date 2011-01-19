module MatchesHelper
  def link_to_match(match, options = {})
    text = options.delete(:text) || "##{match.id}"
    link_to text, match_path(match, options.delete(:path)), options
  end
end
