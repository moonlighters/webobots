module MatchesHelper
  def link_to_match(match)
    link_to "##{match.id}", match_path(match)
  end

  def actions_for_matches
    action "Ваши матчи", matches_path
    action "Все матчи", all_matches_path
    action "Провести матч", new_match_path
  end
end
