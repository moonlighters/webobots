class AddRtErrorBotToMatch < ActiveRecord::Migration
  def self.up
    add_column :matches, :rt_error_bot, :integer
  end

  def self.down
    remove_column :matches, :rt_error_bot
  end
end
