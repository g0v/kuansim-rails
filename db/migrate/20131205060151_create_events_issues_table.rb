class CreateEventsIssuesTable < ActiveRecord::Migration
  def up
    create_table :events_issues, :id => false do |t|
      t.references :event, :issue
    end

    add_index :events_issues, [:event_id, :issue_id]
  end

  def down
    drop_table :events_issues
  end
end
