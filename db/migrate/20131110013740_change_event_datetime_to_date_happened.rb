class ChangeEventDatetimeToDateHappened < ActiveRecord::Migration
  def up
    rename_column :events, :datetime, :date_happened
  end

  def down
  end
end
