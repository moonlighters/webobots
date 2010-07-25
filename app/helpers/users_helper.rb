module UsersHelper
  # Ссылка на профиль пользователя
  #
  # * +u+: собственно пользователь
  # * +opts+:
  #   * <tt>:avatar</tt>: либо просто +true+ (для отображения маленькой аватарки),
  #     либо один из размеров (<tt>:small</tt>, <tt>:normal</tt>, <tt>:big</tt>),
  #     либо +:none+
  def link_to_user(u, opts = {})
    avatar = opts.delete(:avatar) || true

    if avatar && avatar != :none
      size = if [:small, :big, :normal].include? avatar
               avatar
             else
               :small
             end
      link_to(avatar_for(u, :size => size), user_path(u)) + " "
    else
      ""
    end + link_to(h(u.login), user_path(u))
  end

  # Аватар пользователя
  #
  # * +u+: собственно пользователь
  # * +opts+:
  #   * <tt>:size</tt>: один из размеров (<tt>:small</tt>, <tt>:normal</tt>, <tt>:big</tt>)
  def avatar_for(u, opts = {})
    size = opts.delete(:size) || :normal
    case size
    when :small
      av_size = 16
    when :big
      av_size = 120
    when :normal
      av_size = 64
    end

    image_tag u.gravatar_url(:size => av_size), :alt => "аватар", :class => "avatar_" + size.to_s
  end
end
