class CreateMatchReplays < ActiveRecord::Migration
  def self.up
    create_table :match_replays do |t|
      t.text :config
      t.text :frames

      t.belongs_to :match

      t.timestamps
    end
  end

  def self.down
    drop_table :match_replays
  end
end
