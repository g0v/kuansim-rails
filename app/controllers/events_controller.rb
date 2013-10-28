# require 'json'

class EventsController < ApplicationController

	def create
		new_event_params = params[:event]
		if new_event_params.values.select { |val| val != '' }.empty?
			flash[:error] = "Your event was not created. At least one field must be filled out."
		else
			# new_event_json = JSON.parse(new_event_params)
			Event.create(new_event_params)
		end
		redirect_to root_path
	end

	def new
	end

end
