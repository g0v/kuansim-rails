class IssuesController < ApplicationController
  require 'json'

  skip_before_filter :require_login, except: [:create, :delete, :update]

  before_filter :need_id, only: [:delete, :update, :related]

  before_filter lambda { issue_belongs(params[:id]) },
    only: [:delete, :update]

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
    Issue.delete(params[:id])
    render json: { success: true}
  end

  def update
    issue = Issue.find(params[:id]).update_attributes(params[:issue])
    success = issue.valid?
    field, messages = issue.errors.messages.first
    message = (success) ? "" : "#{field} #{messages.first}"
    render json: {
      success: success,
      message: message
    }
  end

  # Return up to 5 "related" issues
  # For now is suppperrrr slow but w/e xD
  def related
    issue = Issue.includes(:events).find(params[:id])
    other_issues = Issue.includes(:events).where('id != ?', params[:id])
    issue_counts = {}
    other_issues.each do |other_issue|

    end
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

  private

    def issue_belongs(issue_id)
      issue = Issue.find(issue_id)
      unless current_user.has_issue?(issue)
        render json: {
          success: false,
          message: "You don't have permission to edit this issue"
        }
        return false
      end
    end

end