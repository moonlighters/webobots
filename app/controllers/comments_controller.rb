class CommentsController < ApplicationController
  before_filter :find_comment, :only => :destroy

  before_filter :require_user
  before_filter :require_owner, :only => :destroy

  def create
    commentable_type = params[:comment][:commentable_type]
    commentable_id = params[:comment][:commentable_id]

    commentable = Comment.find_commentable(commentable_type, commentable_id)

    comment = Comment.new(:comment => params[:comment][:comment], :user => current_user)
    commentable.comments << comment

    redirect_to commentable, :notice => "Комментарий успешно добавлен"
  end

  def destroy
    @comment.destroy
    redirect_to @comment.commentable, :notice => "Комментарий успешно удален"
  end

  private
  def find_comment
    @comment = Comment.find params[:id]
  end

  def require_owner
    generalized_require_owner @comment
  end
end
