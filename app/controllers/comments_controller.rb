class CommentsController < ApplicationController
  before_filter :find_comment, :only => :destroy

  before_filter :require_user
  before_filter :require_owner, :only => :destroy

  def index
    @comments = current_user.relevant_comments.paginate :page => params[:page], :per_page => Comment.per_index_page
  end

  def all
    @comments = Comment.sorted.paginate :page => params[:page], :per_page => Comment.per_index_page
  end

  def create
    commentable_type = params[:comment][:commentable_type]
    commentable_id = params[:comment][:commentable_id]
    @commentable = Comment.find_commentable(commentable_type, commentable_id)

    @comment = @commentable.comments.new params[:comment]
    @comment.user = current_user

    if @comment.save
      if request.xhr?
        render :partial => 'comments/comment', :object => @comment
      else
        redirect_to comments_url(@commentable), :notice => "Комментарий успешно добавлен"
      end
    else
      if request.xhr?
        render :text => 'ERROR'
      else
        render :action => :new
      end
    end
  end

  def destroy
    @comment.destroy
    redirect_to comments_url(@comment.commentable), :notice => "Комментарий успешно удален"
  end

  private
  def find_comment
    @comment = Comment.find params[:id]
  end

  def require_owner
    generalized_require_owner @comment
  end

  def comments_url(commentable)
    polymorphic_url(commentable, :anchor => 'comments')
  end
end
