class Issue < ActiveRecord::Base
  attr_accessible :description, :title
  has_many :events
end
