class CreateUsersIssues < ActiveRecord::Migration
  def change
    create_table :users_issues, :id => false do |t|
      t.references :user, :issue
    end

    add_index :users_issues, [:user_id, :issue_id]
  end
end
