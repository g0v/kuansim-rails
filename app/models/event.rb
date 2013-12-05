class Event < ActiveRecord::Base
  attr_accessible :date_happened, :description, :location, :title, :issue_id, :user_id
  belongs_to :user
  has_and_belongs_to_many :issues
  validates :title, presence: true
  validates :description, presence: true
  validates :date_happened, presence: true

  before_save :parse_date

  def parse_date
    self.date_happened = DateTime.parse(Time.at(self.date_happened.to_f / 1000.0).to_s)
  end

  def as_json(options = {})
    {:id            => self.id,
     :title         => self.title,
     :date_happened => self.date_happened,
     :location      => self.location,
     :description   => self.description}
  end
end
