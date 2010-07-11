class AddAvailableSharedToFirmware < ActiveRecord::Migration
  def self.up
    add_column :firmwares, :available, :boolean, :default => true
    add_column :firmwares, :shared, :boolean, :default => false
  end

  def self.down
    remove_column :firmwares, :shared
    remove_column :firmwares, :available
  end
end
