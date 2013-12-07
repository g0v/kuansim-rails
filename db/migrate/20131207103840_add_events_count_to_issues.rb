class AddEventsCountToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :events_count, :integer
  end
end
