class IssuesController < ApplicationController
  require 'json'

  skip_before_filter :require_login, except: [:create, :destroy, :update]

  before_filter :need_id, only: [:destroy, :update, :related]

  before_filter :issue_exists, only: [:destroy, :update]

  before_filter :issue_belongs, only: [:destroy, :update]

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

  def destroy
    Issue.destroy(params[:id])
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

  # Get top 5 issues with the most events
  def popular
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
    end
    render json: {
      success: true,
      issues: issues
    }
  end

  def timeline
    issue_title = params[:id]
    issue = Issue.find_by_title(issue_title)
    if issue.events != []
      bookmark_list = []
      issue.events.each do |event|
        another_issue = nil
        event.issues.each do |issue_tag|
          if issue_tag.title != issue.title
            another_issue = issue_tag.title
            break
          end
        end
        bookmark_list << {
          :startDate => "#{event.date_happened.year},#{event.date_happened.month},#{event.date_happened.day}",
          :headline => event.title,
          :text => event.description,
          :tag => another_issue,
          :asset => {
            :media => event.url,
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
            :media => bookmark_list.first[:asset][:media],
            :credit => "",
            :caption => ""
          },
          :date => bookmark_list
        }
      }
    else
      render json: {
        :timeline => nil,
        :message => 'There is no bookmark associated with this issue'
      }
    end
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

end