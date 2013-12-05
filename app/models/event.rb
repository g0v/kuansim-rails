class Event < ActiveRecord::Base
  attr_accessible :date_happened, :description, :location, :title, :issue_id, :user_id
  belongs_to :user
  has_and_belongs_to_many :issues

  def as_json(options = {})
    {:id            => self.id,
     :title         => self.title,
     :date_happened => self.date_happened,
     :location      => self.location,
     :description   => self.description}
  end
end
