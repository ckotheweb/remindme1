class CreateReminds < ActiveRecord::Migration[5.0]
  def change
    create_table :reminds do |t|
      t.references :email, foreign_key: true
      t.string :title
      t.text :body
      t.datetime :schedule

      t.timestamps
    end
  end
end
