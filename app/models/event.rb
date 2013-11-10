class Event < ActiveRecord::Base
  attr_accessible :datetime, :description, :location, :title, :issue_id
  has_many :tags
  belongs_to :user
  belongs_to :issue
end
