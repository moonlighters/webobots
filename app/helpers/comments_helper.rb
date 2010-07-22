module CommentsHelper
  def format_comment_text(c)
    simple_format h(c.comment)
  end
end
