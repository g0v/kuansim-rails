require 'json'
require 'date'
require 'net/http' # for handling request
require 'uri'

class EventsController < ApplicationController

  before_filter lambda { event_belongs(params[:id]) },
    except: [:create, :get_event, :get_events, :add_to_bookmark_btn]

  # Will be called by both create and update. If id field is present, it is an update request.
  def create
    new_event_params = params[:event]
    update_id = params[:id]
    json_reply = {success: true}
    event = nil
    if new_event_params.nil?
      json_reply[:success] = false
      json_reply[:message] = "The event was not created. At least one field must be filled out."
    else
      new_event_params[:date_happened] = DateTime.parse(Time.at(new_event_params[:date_happened].to_f / 1000.0).to_s)
      if !current_user.nil? || params['current_bookmark_user']
        if params['current_bookmark_user']
          cookies['user_c'] = params['current_bookmark_user']
          user = User.find(cookies.signed[:user_c])
          if user
            sign_in user
          else
            json_reply[:success] = false
            json_reply[:message] = "The event was not created or updated. You must be logged in to create a new event."
          end
        end
        new_event_params[:user_id] = current_user.id
        if update_id.nil?
          Event.create(new_event_params)
          json_reply[:message] = "The event was created."
        else
          event_id = update_id.to_i
          if Event.find(event_id).nil?
            json_reply[:success] = false
            json_reply[:message] = "The event was not updated. The given id does not match any existing event."
          else
            Event.find(event_id).update_attributes(new_event_params)
            json_reply[:message] = "The event was updated."
          end
        end
      else
        json_reply[:success] = false
        json_reply[:message] = "The event was not created or updated. You must be logged in to create a new event."
      end
    end

    if not event.nil?
      new_event_params[:issues].each do |issue|
        event.issues << issue
      end
      event.save
    end

    render json: json_reply
  end

  def delete
    json_reply = {success: true}
    delete_id = params[:id]
    if params[:id].nil?
      json_reply[:success] = false
      json_reply[:message] = "The event was not deleted. You must select an event first."
    else
      delete_id = delete_id.to_i
      if current_user.nil?
        json_reply[:success] = false
        json_reply[:message] = "The event was not deleted. You must be logged in."
      elsif !current_user.events.include? Event.find(delete_id)
        json_reply[:success] = false
        json_reply[:message] = "The event was not deleted. You must own this event."
      else
        Event.delete(delete_id)
        json_reply[:message] = "The event was deleted."
      end
    end
    render json: json_reply
  end

  def get_event
    json_reply = {success: true}
    event_id = params[:id].to_i
    if event_id.nil?
      json_reply[:success] = false
      json_reply[:message] = "The event was not returned. Param id is required."
    else
      ret_event_json = Event.find(event_id).as_json
      json_reply[:event] = ret_event_json
      json_reply[:message] = 'The event was returned.'
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
      json_reply[:message] = "The events were not returned. Param id must be an integer."
    else
      events_list = Event.take(limit.to_i)
      json_reply[:message] = "The events were returned."
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
    create
  end

  def new
  end

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
