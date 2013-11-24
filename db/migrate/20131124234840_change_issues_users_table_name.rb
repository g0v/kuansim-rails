class ChangeIssuesUsersTableName < ActiveRecord::Migration
  def up
    rename_table :issues_users, :moderators
  end

  def down
  end
end
