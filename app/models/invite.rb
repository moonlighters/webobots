class Invite < ActiveRecord::Base
  validates_presence_of :code, :comment
  validates_length_of :comment, :maximum => 30

  before_validation :generate_code

  def generate_code
    unless code
      self.code = Digest::SHA1.hexdigest( (Time.now.to_i * rand).to_s )
    end
  end
end
