class WelcomeController < ApplicationController
	skip_before_filter  :verify_authenticity_token
	
	def index 
	end

	def new
	end

	def create
		@user = User.find_by_email(params[:session][:email])
  		if @user && @user.authenticate(params[:session][:password])
    		session[:user_id] = @user.id
    		redirect_to '/profile'
  		else
    		redirect_to '/login'
 		 end
	end

	def destroy
		session[:user_id] = nil
		redirect_to '/'
	end
end