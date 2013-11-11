require 'json'
require 'date'

class EventsController < ApplicationController

  def create
    new_event_params = params[:event]
    json_reply = {success: true}
    if new_event_params.nil?
      json_reply[:success] = false
      json_reply[:error] = "The event was not created. At least one field must be filled out."
    else
      new_event_params[:date_happened] = DateTime.parse(Time.at(params[:date_happened].to_i / 1000).to_s)
      if current_user.nil?
        new_event_params[:user_id] = current_user.id
        Event.create(new_event_params)
      else
        json_reply[:success] = false
        json_reply[:error] = "The event was not created. You must be logged in to create a new event."
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
        json_reply[:error] = "The event was not deleted. You must be own this event."  
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
      json_reply[:event] = ret_event
    end
    render json: json_reply
  end

  def get_events
    json_reply = {success: true}
    limit = params[:limit]
    events_list = nil
    if limit.nil?
      events_list = Event.all
    elsif !limit.is_a?(Integer)
      json_reply[:success] = false
      json_reply[:error] = "The events were not returned. Param id must be an integer."
    else
      events_list = Event.take(limit.to_i)
    end
    if !events_list.nil?
      json_reply[:events] = events_list
      puts json_reply
    end
    render json: json_reply
  end

  def new
  end

end
