class CreateFirmwares < ActiveRecord::Migration
  def self.up
    create_table :firmwares do |t|
      t.string :name
      t.belongs_to :user

      t.timestamps
    end
  end

  def self.down
    drop_table :firmwares
  end
end
