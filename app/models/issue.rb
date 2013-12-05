class Issue < ActiveRecord::Base
  attr_accessible :description, :title
  has_and_belongs_to_many :events
  belongs_to :user
  has_and_belongs_to_many :followers, class_name: "User", join_table: 'users_issues'
end
