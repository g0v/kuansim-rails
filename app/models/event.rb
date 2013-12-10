require 'date'
require 'opengraph_parser'

class Event < ActiveRecord::Base

  attr_accessible :date_happened, :description, :location, :title, :issue_id, :user_id, :url, :ogTitle, :ogDescription, :ogImage
  belongs_to :user

  has_many :events_issues
  has_many :issues, through: :events_issues, uniq: true
  validates :title, presence: true
  validates :date_happened, presence: true
  validates :url, presence: true

  before_create :parse_date
  before_save :parse_date
  after_create :set_og_tags

  def parse_date
    if !(self.date_happened.is_a? Time)
      self.date_happened = Time.at((self.date_happened.to_f / 1000.0).to_i).to_datetime
    end
  end

  def as_json(options = {})
    {
      :id            => self.id,
      :title         => self.title,
      :date_happened => self.date_happened,
      :location      => self.location,
      :description   => self.description,
      :url           => self.url,
      :ogTitle       => self.ogTitle,
      :ogDescription => self.ogDescription,
      :ogImage       => self.ogImage
    }
  end

  def issues_titles_list
    issue_title_list = []
    self.issues.each do |i|
      issue_title_list << i.title
    end
    return issue_title_list
  end

  def set_og_tags
    url = self.url
    if (!url.nil?)
      og = OpenGraph.new(url)
      self.update_attributes(:ogTitle => og.title, :ogDescription => og.description, :ogImage => og.images.first)
    end
  end
end
