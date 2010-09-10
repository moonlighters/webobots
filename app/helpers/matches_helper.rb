module MatchesHelper
  def link_to_match(match)
    link_to "##{match.id}", match_path(match)
  end
end
