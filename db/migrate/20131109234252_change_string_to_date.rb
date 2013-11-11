class ChangeStringToDate < ActiveRecord::Migration
  def up
  	change_column :events, :datetime, :datetime
  end

  def down
  end
end
