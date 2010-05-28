class AddFirmwareVersionsToMatch < ActiveRecord::Migration
  def self.up
    add_column :matches, :fwv_id1, :integer
    add_column :matches, :fwv_id2, :integer
  end

  def self.down
    remove_column :matches, :fwv_id2
    remove_column :matches, :fwv_id1
  end
end
