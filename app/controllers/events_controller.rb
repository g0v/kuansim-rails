require 'json'
require 'date'
require 'net/http' # for handling request
require 'uri'

class EventsController < ApplicationController

  # Use lambda to allow params[:id] argument
  before_filter lambda { event_belongs(params[:id]) },
    except: [:create, :get_event, :get_events,]

  # Will be called by both create and update. If id field is present, it is an update request.
  def create
    event_params = params[:event]
    event = Event.create(event_params)
    if event.invalid?
      field, messages = event.errors.messages.first
      render json: {
        success: false,
        message: "#{field} #{messages.first}"
      }
      return
    end

    # Associate chosen issues represented by array of issue_ids
    params[:issues].each do |issue_id|
      event.issues << Issue.find(issue_id)
    end

    # Associate user with event
    current_user.events << event

    render json: { success: true }

  end

  def delete
    json_reply = {success: true}
    delete_id = params[:id]
    if params[:id].nil?
      json_reply[:success] = false
      json_reply[:error] = "The event was not deleted. You must select an event first."
    else
      delete_id = delete_id.to_i
      if current_user.nil?
        json_reply[:success] = false
        json_reply[:error] = "The event was not deleted. You must be logged in."
      elsif !current_user.events.include? Event.find(delete_id)
        json_reply[:success] = false
        json_reply[:error] = "The event was not deleted. You must own this event."
      else
        Event.delete(delete_id)
      end
    end
    render json: json_reply
  end

  def get_event
    json_reply = {success: true}
    event_id = params[:id].to_i
    if event_id.nil?
      json_reply[:success] = false
      json_reply[:error] = "The event was not returned. Param id is required."
    else
      ret_event_json = Event.find(event_id).as_json
      json_reply[:event] = ret_event_json
    end
    render json: json_reply
  end

  def get_events
    json_reply = {success: true}
    limit = params[:limit]
    events_list = []
    if limit.nil?
      events_list = Event.all
    elsif limit != "0" && limit.to_i == 0
      json_reply[:success] = false
      json_reply[:error] = "The events were not returned. Param id must be an integer."
    else
      events_list = Event.take(limit.to_i)
    end
    json_reply[:events] = events_list
    render json: json_reply
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
    event = Event.find(params[:id]).update(params[:event])
    if event.invalid?
      field, messages = event.errors.messages.first
      render json: {
        success: false,
        message: "#{field} #{messages.first}"
      }
      return
    end

    params[:issues].each do |issue_id|
      issue = Issue.find(issue_id)
      event.issues << issue if not event.issues.include?(issue)
    end

    render json: { success: true }

  end

  private

    def event_belongs(event_id)
      event = Event.find(event_id)
      unless current_user.events.include?(event)
        render json: {
          success: false,
          message: "You don't have permission to edit this event"
        }
      end
    end

end
