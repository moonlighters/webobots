class RenameVersionColumnsInMatch < ActiveRecord::Migration
  def self.up
    rename_column :matches, :fwv_id1, :fwv1_id
    rename_column :matches, :fwv_id2, :fwv2_id
  end

  def self.down
    rename_column :matches, :fwv1_id, :fwv_id1
    rename_column :matches, :fwv2_id, :fwv_id2
  end
end
