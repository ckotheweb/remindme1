class AddSentToReminds < ActiveRecord::Migration[5.0]
  def change
    add_column :reminds, :sent, :Boolean
  end
end
