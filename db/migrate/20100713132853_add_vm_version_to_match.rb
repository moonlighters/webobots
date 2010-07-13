class AddVmVersionToMatch < ActiveRecord::Migration
  def self.up
    add_column :matches, :vm_version, :string, :default => '0.1.0'
  end

  def self.down
    remove_column :matches, :vm_version
  end
end
