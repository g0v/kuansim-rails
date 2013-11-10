class AddEventIdToTag < ActiveRecord::Migration
  def change
    add_column :tags, :event_id, :integer
  end
end
