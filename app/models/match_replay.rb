class MatchReplay < ActiveRecord::Base
  belongs_to :match
  validates_presence_of :match

  # +config+ и +frames+ - JSON данные для отображения повтора матча
  validates_presence_of :config, :frames

  def config=(value)
    super(value.to_json)
  end

  def frames=(value)
    super(value.to_json)
  end
end
