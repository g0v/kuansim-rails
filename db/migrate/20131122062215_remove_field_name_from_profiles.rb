class RemoveFieldNameFromProfiles < ActiveRecord::Migration
  def up
    remove_column :profiles, :name
    remove_column :profiles, :email
  end

  def down
    add_column :profiles, :email, :string
    add_column :profiles, :name, :string
  end
end
