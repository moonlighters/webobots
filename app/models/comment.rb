class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  belongs_to :user

  cattr_reader :per_page
  @@per_page = 10
  cattr_reader :per_index_page
  @@per_index_page = 15

  named_scope :sorted, :include => :user, :order => 'created_at DESC'

  validates_presence_of :comment, :user
  validates_length_of :comment, :maximum => 1000
end
