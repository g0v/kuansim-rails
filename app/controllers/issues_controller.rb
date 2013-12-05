class IssuesController < ApplicationController
  require 'json'

  def create
    new_issue_params = params[:issue]
    update_id = params[:id]
    json_reply = {success: true}
    if new_issue_params.nil?
      json_reply[:success] = false
      json_reply[:message] = "The issue was not created. At least one field must be filled out."
    else
      if !current_user.nil?
        if update_id.nil?
          Issue.create(new_issue_params)
          json_reply[:message] = "The issue was created."
        else
          issue_id = update_id.to_i
          if Issue.find(issue_id).nil?
            json_reply[:success] = false
            json_reply[:message] = "The issue was not updated. The given id does not match any existing issue."
          else
            Issue.find(issue_id).update_attributes(new_issue_params)
            json_reply[:message] = "The issue was updated."
          end
        end
      else
        json_reply[:success] = false
        json_reply[:message] = "The issue was not created. You must be logged in to create a new issue."
      end
    end
    render json: json_reply
  end

  def delete
    json_reply = {success: true}
    delete_id = params[:id]
    if params[:id].nil?
      json_reply[:success] = false
      json_reply[:message] = "The issue was not deleted. You must select an issue first."
    else
      delete_id = delete_id.to_i
      if current_user.nil?
        json_reply[:success] = false
        json_reply[:message] = "The issue was not deleted. You must be logged in."
      else
        Issue.delete(delete_id)
        json_reply[:message] = "The issue was deleted."
      end
    end
    render json: json_reply
  end

  def update
    create
  end

  def get_issue
    json_reply = {success: true}
    issue_id = params[:id].to_i
    if issue_id.nil?
      json_reply[:success] = false
      json_reply[:message] = "The event was not returned. Param id is required."
    else
      ret_issue_json = Issue.find(issue_id).as_json
      json_reply[:issue] = ret_issue_json
      json_reply[:message] = "The event was returned."
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
    issue_id = params[:id]
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