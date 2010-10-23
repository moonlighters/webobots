FriendlyId::Configuration::DEFAULTS[:reserved_message] = "Такое значение (%s) недопустимо"

class ActiveRecord::Base
  def self.find_friendly(friendly_id, *args)
    self.find(friendly_id, *args).tap do |record|
      status = record.friendly_id_status
      unless status.friendly? and status.best?
        raise ActiveRecord::RecordNotFound, "Couldn't find #{self} with ID=#{friendly_id}"
      end
    end
  end
end
