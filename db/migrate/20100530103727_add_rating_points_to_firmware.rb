class AddRatingPointsToFirmware < ActiveRecord::Migration
  def self.up
    add_column :firmwares, :rating_points, :float, :default => 0
  end

  def self.down
    remove_column :firmwares, :rating_points
  end
end
