class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  belongs_to :user

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  cattr_reader :per_page
  @@per_page = 10

  # Пагинация по умолчанию
  #
  # Функция сама вынимает нужный параметр с номером
  # страницы из +params+, чтобы использующие её
  # контроллеры не зависели от того, как он называется
  def self.default_paginate(params)
    self.paginate :page => params[:comments_page], :include => :user, :order => 'created_at DESC'
  end
end
