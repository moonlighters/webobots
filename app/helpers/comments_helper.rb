module CommentsHelper
  def format_comment_text(text)
    h(text).gsub "\n", "<br/>\n"
  end
end
