class DropEventsIssues < ActiveRecord::Migration
  def up
    drop_table :events_issues
  end

  def down
  end
end
