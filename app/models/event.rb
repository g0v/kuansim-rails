class Event < ActiveRecord::Base
<<<<<<< HEAD
  attr_accessible :datetime, :description, :location, :title

  belongs_to :user
=======
  attr_accessible :datetime, :description, :location, :title, :issue_id
  has_many :tags
  belongs_to :issue
>>>>>>> origin/json-api
end
