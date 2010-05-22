module UsersHelper
  def link_to_user(u)
    link_to h(u.login), user_path(u)
  end
end
