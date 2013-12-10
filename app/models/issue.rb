class Issue < ActiveRecord::Base
  attr_accessible :description, :title
  belongs_to :user

  has_many :issues_users
  has_many :events_issues
  has_many :followers, through: :issues_users,
    class_name: "User", uniq: true
  has_many :events,
    through: :events_issues, uniq: true
  validates :title, presence: true, uniqueness: true
  # validates :description, presence: true

  # Will order by count of events
  scope :popular, where('events_count > 0').order('events_count DESC')

  def to_hash
    {
      id: self.id,
      title: self.title,
      description: self.description
    }
  end

  # Return up to 5 "related" issues
  # For now is suppperrrr slow but w/e xD
  def related_issues
    # issue = Issue.includes(:events).find(params[:id])
    # other_issues = Issue.includes(:events).where('id != ?', params[:id])
    issue = self
    other_issues = Issue.includes(:events).where('id != ?', self.id)
    issue_counts = Hash.new(0)
    other_issues.each do |other_issue|
      other_issue.events.each do |event|
        if issue.events.include?(event)
          issue_counts[other_issue] += 1
        end
      end
    end

    # Gets related issues by seeing which issues have the most events
    # in common
    related_issues = issue_counts.select{|k, v| v > 0 }.
      sort_by {|k, v| v}.
      reverse[0..4].
      map {|k, v| k.to_hash}
    
    related_issues
    # render json: {
    #   success: true,
    #   related: related_issues
    # }
  end

end
