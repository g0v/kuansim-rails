class Event < ActiveRecord::Base
  attr_accessible :date_happened, :description, :location, :title, :issue_id, :user_id
  has_many :tags
  belongs_to :user
  belongs_to :issue

  def as_json(options = {})
    {:id            => self.id,
     :title         => self.title,
     :date_happened => self.date_happened,
     :location      => self.location,
     :description   => self.description}
  end
end
