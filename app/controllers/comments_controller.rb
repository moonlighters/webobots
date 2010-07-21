class CommentsController < ApplicationController
  before_filter :require_user

  def create
    commentable_type = params[:comment][:commentable_type]
    commentable_id = params[:comment][:commentable_id]

    commentable = Comment.find_commentable(commentable_type, commentable_id)

    comment = Comment.new(:comment => params[:comment][:comment], :user => current_user)
    commentable.comments << comment

    redirect_to commentable, :notice => "Комментарий успешно добавлен"
  end
end
