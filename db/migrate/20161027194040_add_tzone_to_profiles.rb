class AddTzoneToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :timezone, :string
  end
end
