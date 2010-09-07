module UsersHelper
  # Доступные размеры аватарки
  AVATAR_SIZES = {
    :tiny => 16,
    :small => 48,
    :medium => 64,
    :big => 120
  }

  # Ссылка на профиль пользователя
  #
  # * +u+: собственно пользователь
  # * +opts+:
  #   * <tt>:avatar</tt>: либо просто +true+ (для отображения крошечной аватарки, по умолчанию),
  #     либо один из размеров, либо +:none+
  #   * <tt>:login</tt>: показывать ли логин пользователя (по умолчанию +true+)
  def link_to_user(u, opts = {})
    avatar = opts.delete(:avatar) || true
    login = opts.delete(:login)
    login = true if login.nil?

    raise ArgumentError unless avatar || login

    avatar_part = if avatar && avatar != :none
                    size = if AVATAR_SIZES.include? avatar
                             avatar
                           else
                             :tiny
                           end
                    link_to(avatar_for(u, :size => size), user_path(u), :class => "avatar_link") + " "
                  else
                    ""
                  end

    login_part = if login
                   link_to(h(u.login), user_path(u))
                 else
                   ""
                 end

    avatar_part + login_part
  end

  # Аватар пользователя
  #
  # * +u+: собственно пользователь
  # * +opts+:
  #   * <tt>:size</tt>: один из размеров
  def avatar_for(u, opts = {})
    size = opts.delete(:size) || :tiny
    av_size = AVATAR_SIZES[size] or raise ArgumentError, "unknown size #{size.to_s}"
    alt = size == :tiny ? "" : h(u.login)

    image_tag u.gravatar_url(:size => av_size), :alt => alt, :class => "avatar_" + size.to_s
  end

  def actions_for_user(user, has_firmwares)
    action "Пользователь", user_path(user)
    action "Аккаунт", edit_account_path if current_user == user

    link "Сразиться!", new_match_path(:enemy => user) if has_firmwares
    link "Список матчей", user_matches_path(user)
  end
end
