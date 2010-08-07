class AddConstraintsToFirmwareVersion < ActiveRecord::Migration
  def self.up
    change_column :firmware_versions, :firmware_id, :integer, :null => false
  end

  def self.down
    change_column :firmware_versions, :firmware_id, :integer
  end
end
