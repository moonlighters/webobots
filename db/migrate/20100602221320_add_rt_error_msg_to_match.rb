class AddRtErrorMsgToMatch < ActiveRecord::Migration
  def self.up
    add_column :matches, :rt_error_msg, :string
  end

  def self.down
    remove_column :matches, :rt_error_msg
  end
end
