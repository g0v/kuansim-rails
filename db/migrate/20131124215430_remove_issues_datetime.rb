class RemoveIssuesDatetime < ActiveRecord::Migration
  def up
    remove_column :issues, :datetime
  end

  def down
  end
end
