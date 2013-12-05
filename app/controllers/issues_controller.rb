class IssuesController < ApplicationController
  require 'json'

  def create
    issue = Issue.create(params[:issue])
    if issue.valid?
      current_user.issues << issue
      render json: { success: true }
    else
      field, messages = issue.errors.messages.first
      render json: {
        success: false,
        message: "#{field} #{messages.first}"
      }
    end

  end

  def delete
    json_reply = {success: true}
    delete_id = params[:id]
    if params[:id].nil?
      json_reply[:success] = false
      json_reply[:error] = "The issue was not deleted. You must select an issue first."
    else
      delete_id = delete_id.to_i
      if current_user.nil?
        json_reply[:success] = false
        json_reply[:error] = "The issue was not deleted. You must be logged in."
      else
        Issue.delete(delete_id)
      end
    end
    render json: json_reply
  end

  def update
    issue = Issue.find(params[:id]).update(params[:issue])
    success = issue.valid?
    field, messages = issue.errors.messages.first
    message = (success) ? "" : "#{field} #{messages.first}"
    render json: {
      success: success,
      message: message
    }
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