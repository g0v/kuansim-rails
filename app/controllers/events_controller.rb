require 'json'
require 'date'
require 'net/http' # for handling request
require 'uri'

class EventsController < ApplicationController

  skip_before_filter :require_login, only: [:index, :show]

  # Check that params[:id] exists using function from ApplicationController
  before_filter :need_id, only: [:destroy, :show, :update]

  before_filter :event_exists, only: [:destroy, :show, :update]

  # Use lambda to allow params[:id] argument
  before_filter :event_belongs, only: [:update, :destroy]

  def create
    event_params = params[:event]
    if event_params && !(event_params[:date_happened].is_a? Integer) # jQuery will automatically make the
                                                     # request string, parse it to integer
      event_params[:date_happened] = event_params[:date_happened].to_f
    end
    event = Event.create(event_params)
    if event.invalid?
      field, messages = event.errors.messages.first
      render json: {
        success: false,
        message: "#{field} #{messages.first}"
      }
      return
    end

    issues = params[:issues] || []
    # Associate chosen issues represented by array of issue_ids
    issues.each do |issue_id|
      event.issues << Issue.find(issue_id)
    end

    # Associate user with event
    current_user.events << event

    render json: { success: true }
  end

  def destroy
    Event.destroy(params[:id])
    render json: {success: true}
  end

  def show
    event = Event.find(params[:id])
    render json: {
      success: true,
      event: event.to_json
    }
  end

  def index
    limit = params[:limit] || "all"
    event_list = case limit
    when "all"
      Event.all
    when /^[-+]?[0-9]+$/
      Event.limit(limit)
    else
      []
    end

    render json: {
      success: true,
      events: event_list
    }
  end

  def add_to_bookmark_btn
    # This fn deals with external `add to bookmark` button view request

    @user_id = cookies.signed[:user_c]

    if @user_id.nil?
      render :add_to_bookmark_btn ,:layout => false
    elsif not user_signed_in? or current_user.id != @user_id
      if user_signed_in?
        sign_out current_user
      end

      user = User.find(@user_id)
      if user
        sign_in user
        session['current_bookmark_user'] = cookies.signed[:user_c]
        render :add_to_bookmark_btn ,:layout => false
      else
        render :add_to_bookmark_btn ,:layout => false
      end
    else
      session['current_bookmark_user'] = cookies.signed[:user_c]
      render :add_to_bookmark_btn ,:layout => false
    end
  end

  def update
    event = Event.find(params[:id])
    event.update_attributes(params[:event])
    if event.invalid?
      field, messages = event.errors.messages.first
      render json: {
        success: false,
        message: "#{field} #{messages.first}"
      }
      return
    end
    issues = params[:issues] || []

    issues.each do |issue_id|
      issue = Issue.find(issue_id)
      event.issues << issue
    end

    render json: { success: true }

  end

  private

    def event_belongs
      unless current_user.has_event?(params[:id])
        render json: {
          success: false,
          message: "You don't have permission to edit this event"
        }
      end
      return false
    end

    def event_exists
      unless Event.exists?(id: params[:id])
        render json: {
          success: false,
          message: "Event does not exist"
        }
        return false
      end
    end
end
