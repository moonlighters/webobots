class AddRatingPointsToMatch < ActiveRecord::Migration
  def self.up
    add_column :matches, :first_points, :float, :default => 0
    add_column :matches, :second_points, :float, :default => 0
  end

  def self.down
    remove_column :matches, :first_points
    remove_column :matches, :second_points
  end
end
