class Issue < ActiveRecord::Base
  attr_accessible :description, :title
  has_many :events
  has_and_belongs_to_many :users
end
