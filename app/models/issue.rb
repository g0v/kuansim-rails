class Issue < ActiveRecord::Base
  attr_accessible :description, :title
  has_and_belongs_to_many :events, uniq: true
  belongs_to :user
  has_and_belongs_to_many :followers, class_name: "User", join_table: 'users_issues', uniq: true

  validates :title, presence: true
  validates :description, presence: true

  def to_hash
    {
      id: self.id,
      title: self.title,
      description: self.description
    }
  end
end
