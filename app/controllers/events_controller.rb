require 'json'

class EventsController < ApplicationController

  def create
    new_event_params = params[:event]
    json_reply = {success: true}
    if new_event_params.nil?
      json_reply[:success] = false
      json_reply[:error] = "Your event was not created. At least one field must be filled out."
    else
      new_event_params[:date_happened] = DateTime.new( new_event_params[:year].to_i,
                                                  new_event_params[:month].to_i,
                                                  new_event_params[:day].to_i )
      new_event_params.delete("year")
      new_event_params.delete("month")
      new_event_params.delete("day")
      Event.create(new_event_params)
    end
    render json: json_reply
  end

  def delete
    json_reply = {success: true}
    delete_id = params[:id].to_i
    if delete_id.nil?
      json_reply[:success] = false
      json_reply[:error] = "Your event was not deleted. An event must be selected."
    else
      Event.delete(delete_id)
    end
    render json: json_reply
  end

  def get_event
    json_reply = {success: true}
    event_id = params[:id].to_i
    if event_id.nil?
      json_reply[:success] = false
      json_reply[:error] = "Your event was not returned. Param id is required."
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
      json_reply[:error] = "Your events were not returned. Param id must be an integer."
    else
      events_list = Event.take(limit.to_i)
    end
    if !events_list.nil?
      json_reply[:events] = events_list.map{ |evt| evt.to_json }.to_json
    end
    render json: json_reply
  end

  def new
  end

end
