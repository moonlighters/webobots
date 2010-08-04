class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.login_field = :login
    config.validates_format_of_login_field_options = {
      :with => /^\w[-._\w\d]+$/,
      :message => "должен содержать только буквы, цифры и .-_"
    }
  end

  is_gravtastic :default => :mm

  attr_protected :login

  cattr_reader :per_page
  @@per_page = 10
  cattr_reader :per_page_of_rating
  @@per_page_of_rating = 10

  has_many :firmwares

  has_many :conducted_matches, :class_name => 'Match'

  # has_many :matches, :through => :firmwares
  MATCHES_SQL = %q{
    INNER JOIN firmware_versions ON
      ( matches.fwv1_id = firmware_versions.id OR matches.fwv2_id = firmware_versions.id )
    INNER JOIN firmwares ON firmware_versions.firmware_id = firmwares.id
    WHERE (firmwares.user_id = #{id})
  }
  has_many :matches, :finder_sql  => 'SELECT DISTINCT matches.* FROM matches' + MATCHES_SQL,
                     :counter_sql => 'SELECT COUNT(DISTINCT matches.id) FROM matches' + MATCHES_SQL

  def sql_ids(ids); ids.empty? ? 'NULL' : ids.uniq.join(',') end
  has_many :relevant_comments, :class_name => 'Comment', :finder_sql => %q|
    SELECT * FROM comments
    WHERE (
      user_id = #{id} OR
      commentable_type = 'User'     AND commentable_id = #{id} OR
      commentable_type = 'Firmware' AND commentable_id IN (#{sql_ids firmware_ids}) OR
      commentable_type = 'Match'    AND commentable_id IN (#{sql_ids match_ids + conducted_match_ids})
    )
    ORDER BY created_at DESC
  | do
    def find(*args)
      options = args.extract_options!
      sql = @finder_sql

      sql += sanitize_sql [" LIMIT ?", options[:limit]] if options[:limit]
      sql += sanitize_sql [" OFFSET ?", options[:offset]] if options[:offset]

      Comment.find_by_sql(sql)
    end
  end


  acts_as_commentable

  validates_length_of :login, :maximum => 20

  # +code+ используется как код инвайта при регистрации
  attr_accessor :code
  validates_presence_of :code, :on => :create
  validate_on_create :check_invite_code
  before_create :destroy_invite

  attr_writer :rating_points
  def rating_points
    @rating_points ||= firmwares.sum( :rating_points )
  end

  attr_writer :rating_position
  def rating_position
    @rating_position ||=
      begin
        user_points = Firmware.sum :rating_points, :joins => :user, :group => :user_id
        1 + user_points.count {|_,points| points > user_points.fetch(self.id, 0.0) }
      end
  end

  def owns?(obj)
    obj.respond_to?(:user) && obj.user == self
  end

  def self.all_sorted_by_rating
    users = User.scoped :select => 'users.*,SUM(rating_points) as sum_rating_points',
                        :joins => 'LEFT OUTER JOIN firmwares ON firmwares.user_id = users.id',
                        :group => 'users.id',
                        :order => 'sum_rating_points DESC'
    pos = 0
    val = nil
    users.each_with_index do |u, i|
      u.rating_points = (u.sum_rating_points || 0.0).to_f
      if u.rating_points != val
        val = u.rating_points
        pos = i + 1
      end
      u.rating_position = pos
    end
  end

  private

  def check_invite_code
    # хак для тестов
    return if Rails.env.test? and code == '1234'

    if not code.blank? and Invite.find_by_code( code ).nil?
      errors.add :code, "недействительный"
    end
  end

  def destroy_invite
    # хак для тестов
    return if Rails.env.test? and code == '1234'

    Invite.find_by_code( code ).destroy
  end

end
