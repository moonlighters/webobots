class AddMessageToFirmwareVersion < ActiveRecord::Migration
  def self.up
    add_column :firmware_versions, :message, :text
  end

  def self.down
    remove_column :firmware_versions, :message
  end
end
