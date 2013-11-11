require 'json'
require 'date'

class EventsController < ApplicationController

  # Will be called by both create and update. If id field is present, it is an update request.
  def create
    new_event_params = params[:event]
    update_id = params[:id]
    json_reply = {success: true}
    if new_event_params.nil?
      json_reply[:success] = false
      json_reply[:error] = "The event was not created. At least one field must be filled out."
    else
      new_event_params[:date_happened] = DateTime.parse(Time.at(new_event_params[:date_happened].to_f / 1000.0).to_s)
      if !current_user.nil?
        new_event_params[:user_id] = current_user.id
        if update_id.nil?
          Event.create(new_event_params)
        else
          event_id = update_id.to_i
          if Event.find(event_id).nil?
            json_reply[:success] = false
            json_reply[:error] = "The event was not updated. The given id does not match any existing event."
          else
            Event.find(event_id).update_attributes(new_event_params)
          end
        end
      else
        json_reply[:success] = false
        json_reply[:error] = "The event was not created or updated. You must be logged in to create a new event."
      end
    end
    render json: json_reply
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

  def update
    create
  end

  def new
  end

end
