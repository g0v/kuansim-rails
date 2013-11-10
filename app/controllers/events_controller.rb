# require 'json'

class EventsController < ApplicationController

  def create
    new_event_params = params[:event]
    json_reply = {success: true}
    if new_event_params.values.select { |val| val != '' }.empty?
      json_reply[:success] = false
      json_reply[:error] = "Your event was not created. At least one field must be filled out."
    else
      # new_event_json = JSON.parse(new_event_params)
      Event.create(new_event_params)
    end
    render json: json_reply
  end

  def new
  end

end
