class IssuesController < ApplicationController
  require 'json'

  def create
    new_issue_params[:issue]
    json_reply = {success: true}
    if new_issue_params.nil?
      json_reply[:success] = false
      json_reply[:error] = "The issue was not created. At least one field must be filled out."
    else
      if !current_user.nil?
        Issue.create(new_issue_params)
      else
        json_reply[:success] = false
        json_reply[:error] = "The issue was not created. You must be logged in to create a new issue."
      end
    end
    render json: json_reply
  end

  def list_all_issues
    return_json = []
    Issue.find(:all).each do |issue|
      return_json << {
        :id => issue.id,
        :title => issue.title,
        :description => issue.description
      }
    end
    render json: return_json
  end

  def timeline
    issue_id = params[:issue_id]
    issue = Issue.find_by_id(issue_id)
    events_list = []
    issue.events.each do |event|
      tags_list = []
      event.tags.each do |tag|
        tags_list << tag.name
      end
      events_list << {
        :startDate => "#{event.date_happened.year},#{event.date_happened.month},#{event.date_happened.day}",
        :headline => event.title,
        :text => event.description,
        :tag => tags_list.join(", "),
        :asset => {
          :media => "",
          :credit => "",
          :caption => ""
        }
      }
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