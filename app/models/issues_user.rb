class IssuesUser < ActiveRecord::Base
  attr_accessible :issue_id, :user_id

  belongs_to :user
  belongs_to :issue
end
