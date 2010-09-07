module CommentsHelper
  def format_comment_text(c)
    simple_format h(c.comment)
  end

  def actions_for_comments
    action "Интересные", comments_path
    action "Все", all_comments_path
  end
end
