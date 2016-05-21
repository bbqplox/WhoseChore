class WelcomeController < ApplicationController
	skip_before_filter  :verify_authenticity_token

	def index
		render layout: false
		return
		# If a user is already logged in just redirect to their profile
		if current_user
			redirect_to '/main'
		end
	end

	def new
	end

	def create
		@user = User.find_by_email(params[:session][:email])
  		if @user && @user.authenticate(params[:session][:password])
    		session[:user_id] = @user.id
    		redirect_to '/main'
  		else
    		redirect_to '/login'
 		 end
	end

	def destroy
		session[:user_id] = nil
		redirect_to '/'
	end

	def exisiting
		redirect_to show_profile_path
	end

end
