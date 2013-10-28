class Event < ActiveRecord::Base
  attr_accessible :datetime, :description, :location, :title
end
