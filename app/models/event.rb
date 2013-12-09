require 'date'
require 'opengraph_parser'

class Event < ActiveRecord::Base
  attr_accessible :date_happened, :description, :location, :title, :issue_id, :user_id, :url
  belongs_to :user

  has_many :events_issues
  has_many :issues, through: :events_issues, uniq: true
  validates :title, presence: true
  validates :date_happened, presence: true
  validates :url, presence: true

  before_create :parse_date

  def parse_date
    self.date_happened = Time.at((self.date_happened.to_f / 1000.0).to_i).to_datetime
  end

  def as_json(options = {})
    {
      :id            => self.id,
      :title         => self.title,
      :date_happened => self.date_happened,
      :location      => self.location,
      :description   => self.description,
      :url           => self.url
    }
  end

  def issues_titles_list
    issue_title_list = []
    self.issues.each do |i|
      issue_title_list << i.title
    end
    return issue_title_list
  end

  def og_tags
    url = self.url
    if (url)
      og = OpenGraph.new(url)
      og_tags = {
        title: og.title,
        description: og.description,
        images: og.images
      }
    end
    return og_tags
  end
end
