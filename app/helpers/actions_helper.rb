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
    action "Список матчей", user_matches_path(user)

    link "Прошивки", firmwares_user_path(user)
    link "Сразиться!", new_match_path(:enemy => user) if has_firmwares
  end

  def actions_for_match(match)
    action "Матч", match_path(match)
    action "Повтор матча", play_match_path(match), :class => 'nyroModal show-replay' unless @match.failed?

    link "Ваши матчи", matches_path unless current_user.nil?
    link "Все матчи", all_matches_path
    link "Провести матч", new_match_path unless current_user.nil?
  end

  def actions_for_matches
    return if current_user.nil?

    action "Ваши матчи", matches_path
    action "Все матчи", all_matches_path
    action "Провести матч", new_match_path
  end

  def actions_for_firmware(fw)
    u = fw.user
    action "Прошивка", user_firmware_path(u, fw)
    action "Редактировать", edit_user_firmware_path(u, fw) if current_user.owns? fw
    action "История версий", user_firmware_versions_path(u, fw)

    link "Сразиться!", new_match_path(:enemy => u, :enemy_fw => fw) if can_fight_with? fw
    link "Список матчей", user_firmware_matches_path(u, fw)
  end

  def actions_for_firmwares_of(user)
    action "Прошивки", user_firmwares_path(user)
    action "Новая прошивка", new_user_firmware_path

    link "Все прошивки", firmwares_rating_path
  end

  def actions_for_rating
    return if current_user.nil?

    action "Пользователи", users_rating_path
    action "Прошивки", firmwares_rating_path
  end

  def actions_for_comments
    action "Интересные", comments_path
    action "Все", all_comments_path
  end

  def actions_for_admin
    action "Статистика", stats_admin_path
    action "Инвайты", admin_invites_path
  end

  def actions_for_doc
    action "Тур по сайту", tour_doc_path
    action "Обучение", tutorial_doc_path
    action "Язык WaFfLe", waffle_language_doc_path
    action "Станд. функции", runtime_library_doc_path
  end
end
