class IssuesController < ApplicationController
  require 'json'

  def timeline(issue_id)
    issue = Issue.where(:id => issue_id)

    events = issue.events
    events_list = []
    events.each do |event|
      tags_list = []
      event.tags.each do |tag|
        tags_list << tag.name
      end
      events_list << {
        :startDate => event.datetime,
        :headline => event.title,
        :text => event.description,
        :tag => tags_list.join(", "),
        :asset => {
          :media => "",
          :credit => "",
          :caption => ""
        }
      }.to_json

      render json: events_list
    end
    
    render json: {
      :timeline => {
        :headline => issue.title, 
        :type => "default", 
        :text => issue.description, 
        :asset => {
          :media => "",
          :credit => "",
          :caption => ""
        },
        :date => events_list
      }
    }
  end

end