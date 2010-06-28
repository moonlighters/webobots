class ResizeFramesInReplay < ActiveRecord::Migration
  def self.up
    change_column :match_replays, :frames, :mediumtext
  end

  def self.down
    change_column :match_replays, :frames, :text
  end
end
