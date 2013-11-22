class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :email
      t.string :website
      t.string :github

      t.timestamps
    end
  end
end
