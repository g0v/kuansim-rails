# require 'json'

class EventsController < ApplicationController

	def create
		new_event_params = params[:event]
		# new_event_json = JSON.parse(new_event_params)
		Event.create(new_event_params)
	end

end
