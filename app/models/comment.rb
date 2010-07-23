class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  belongs_to :user

  cattr_reader :per_page
  @@per_page = 10

  named_scope :sorted, :include => :user, :order => 'created_at DESC'
end
