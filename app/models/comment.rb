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

  named_scope :relevant_to, lambda {|user|
    {
      :conditions => ["
        user_id = :user_id OR
        commentable_type = 'User'     AND commentable_id = :user_id OR
        commentable_type = 'Firmware' AND commentable_id IN (:firmware_ids) OR
        commentable_type = 'Match'    AND commentable_id IN (:match_ids)
        ", {
          :user_id => user.id,
          :firmware_ids => user.firmwares,
          :match_ids => (user.matches + user.conducted_matches)
        }]
    }
  }
end
