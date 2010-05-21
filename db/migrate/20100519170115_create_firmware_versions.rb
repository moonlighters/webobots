class CreateFirmwareVersions < ActiveRecord::Migration
  def self.up
    create_table :firmware_versions do |t|
      t.belongs_to :firmware
      t.integer :number
      t.text :code

      t.timestamps
    end
  end

  def self.down
    drop_table :firmware_versions
  end
end
