class IssuesController < ApplicationController
  require 'json'

  skip_before_filter :require_login, except: [:create, :delete, :update]

  before_filter :need_id, only: [:delete, :update, :related]

  before_filter :issue_exists, only: [:delete, :update]

  before_filter :issue_belongs, only: [:delete, :update]

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
    render json: { success: true }
  end

  def update
    issue = Issue.find(params[:id])
    issue.update_attributes(params[:issue])
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
      map {|k, v| k.to_json}

    render json: {
      success: true,
      related: related_issues
    }
  end

  # Get top 5 issues with the most events
  def popular
    # query = %Q(
    #   select issue_id
    #   from events_issues
    #   group by issue_id
    #   having count(issue_id)>0
    #   order by count(issue_id) desc
    #   limit 5
    # )
    # result = ActiveRecord::Base.connection.execute(query)
    # issues = result.map do |e|
    #   Issue.find(e["issue_id"])
    # end
    # render json: {
    #   success: true,
    #   issues: issues
    # }
    render json: {
      success: true,
      issues: Issue.popular.limit(5)
    }
  end

  def index
    issues = Issue.all.map do |issue|
      issue.to_hash.merge(
        isFollowed: current_user.follows_issue?(issue.id)
      )

    render json: {
      success: true,
      issues: issues
    }
    end
  end

  def list_all_issues
    return_json = []
    Issue.find(:all).each do |issue|
      return_json << {
        id: issue.id,
        title: issue.title,
        description: issue.description,
        isFollowed: current_user.follows_issue?(issue.id)
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

    def issue_belongs
      unless current_user.has_issue?(params[:id])
        render json: {
          success: false,
          message: "You don't have permission to edit this issue"
        }
        return false
      end
    end

    def issue_exists
      unless Issue.exists?(id: params[:id])
        render json: {
          success: false,
          message: "Issue does not exist"
        }
        return false
      end
    end

end