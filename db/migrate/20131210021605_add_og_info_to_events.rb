class AddOgInfoToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ogTitle, :string
    add_column :events, :ogDescription, :string
    add_column :events, :ogImage, :string
  end
end
