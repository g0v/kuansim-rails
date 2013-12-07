class EventsIssue < ActiveRecord::Base
  attr_accessible :event_id, :issue_id

  belongs_to :event
  belongs_to :issue, counter_cache: :events_count
end
