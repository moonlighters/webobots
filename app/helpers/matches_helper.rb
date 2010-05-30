module MatchesHelper
  def link_to_match(match)
    link_to "##{match.id}, #{format_datetime(match.created_at)}", match_path(match)
  end
end
