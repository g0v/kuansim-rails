class CreateEventsIssues < ActiveRecord::Migration
  def change
    create_table :events_issues do |t|
      t.integer :event_id
      t.integer :issue_id

      t.timestamps
    end
  end
end
