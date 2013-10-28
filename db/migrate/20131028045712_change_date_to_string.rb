class ChangeDateToString < ActiveRecord::Migration
  def up
  	change_column :events, :datetime, :string
  end

  def down
  end
end
