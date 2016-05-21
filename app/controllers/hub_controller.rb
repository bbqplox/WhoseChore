class HubController < ApplicationController

	def index
		@user = User.find(session[:user_id])
	end

	def edit
		@user = User.find(session[:user_id])
	end

	def show
		@user = User.find(session[:user_id])
	end
end
