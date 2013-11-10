class AddIssueIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :issue_id, :integer
  end
end
