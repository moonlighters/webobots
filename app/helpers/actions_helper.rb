module ActionsHelper
  # Принимает такие же параметры как и <tt>link_to</tt>
  def action(*action)
    @actions ||= []
    @actions << action
  end

  # Принимает такие же параметры как и <tt>link_to</tt>
  def link(*link)
    @links ||= []
    @links << link
  end

  def has_actions_or_links?
    @actions.present? || @links.present?
  end

  def has_both_actions_and_links?
    @actions.present? && @links.present?
  end

  def list_items(array) # :nodoc:
    (array || []).compact.map { |item| content_tag :li, link_to( *item ) } * "\n"
  end

  def actions_list
    list_items @actions
  end

  def links_list
    list_items @links
  end

  def actions_for_anonymous
    action "Вход", login_path
    action "Регистрация", signup_path
  end

  def actions_for_user(user, has_firmwares)
    action "Пользователь", user_path(user)
    action "Аккаунт", edit_account_path if current_user == user
    action "Прошивки", firmwares_user_path(user)

    link "Сразиться!", new_match_path(:enemy => user) if has_firmwares
    link "Список матчей", user_matches_path(user)
  end

  def actions_for_match(match)
    action "Матч", match_path(match)
    action "Повтор матча", play_match_path(match), :id => 'show-replay', :class => 'nyroModal' unless @match.failed?

    link "Ваши матчи", matches_path
    link "Все матчи", all_matches_path
    link "Провести матч", new_match_path
  end

  def actions_for_matches
    action "Ваши матчи", matches_path
    action "Все матчи", all_matches_path
    action "Провести матч", new_match_path
  end

  def actions_for_firmware(fw)
    action "Прошивка", firmware_path(fw)
    action "Редактировать", edit_firmware_path(fw) if current_user.owns? fw
    action "История версий", firmware_versions_path(fw)

    link "Сразиться!", new_match_path(:enemy_fw => fw) if can_fight_with? fw
    link "Список матчей", firmware_matches_path(fw)
  end

  def actions_for_firmwares
    action "Ваши прошивки", firmwares_path
    action "Все прошивки", all_firmwares_path
    action "Новая прошивка", new_firmware_path
  end

  def actions_for_rating
    action "Пользователи", users_rating_path
    action "Прошивки", firmwares_rating_path
  end

  def actions_for_comments
    action "Интересные", comments_path
    action "Все", all_comments_path
  end

  def actions_for_admin
    action "Статистика", stats_admin_path
    action "Управление инвайтами", admin_invites_path
  end
end
