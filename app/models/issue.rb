class Issue < ActiveRecord::Base
  attr_accessible :description, :title
  belongs_to :user

  has_many :issues_users
  has_many :events_issues
  has_many :followers, through: :issues_users,
    class_name: "User", uniq: true
  has_many :events,
    through: :events_issues, uniq: true
  validates :title, presence: true
  validates :description, presence: true

  # Will order by count of events
  scope :popular, where('events_count > 0').order('events_count DESC')

  def to_hash
    {
      id: self.id,
      title: self.title,
      description: self.description
    }
  end

end
