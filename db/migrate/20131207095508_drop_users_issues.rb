class DropUsersIssues < ActiveRecord::Migration
  def up
    drop_table :users_issues
  end

  def down
  end
end
