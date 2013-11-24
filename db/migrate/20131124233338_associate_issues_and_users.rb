class AssociateIssuesAndUsers < ActiveRecord::Migration
  def change
    create_table :issues_users do |t|
      t.belongs_to :issues
      t.belongs_to :users
    end
  end
end
