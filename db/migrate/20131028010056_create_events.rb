class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :datetime
      t.string :location
      t.text :description

      t.timestamps
    end
  end
end
