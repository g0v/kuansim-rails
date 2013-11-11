class ChangeStringToDate < ActiveRecord::Migration
  def up
  	change_column :events, :date_happened, :datetime
  end

  def down
  end
end
