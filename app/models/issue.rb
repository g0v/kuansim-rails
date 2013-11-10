class Issue < ActiveRecord::Base
  attr_accessible :datetime, :description, :title
  has_many :events
end
