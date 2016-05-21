class UsersController < ApplicationController

	def new
		@user = User.new
	end

	def create
	    @user = User.new(user_params)
	    if @user.save
	      session[:user_id] = @user.id
	      redirect_to '/main'
	    else
	      redirect_to '/signup'
		end
	end

	def show
		@user = current_user
		redirect_to @user.profile
	end

	def index
  		@users = User.search_index(params[:search])
	end

	private
	def user_params
		params.require(:user).permit(:first_name, :last_name, :email, :password)
	end

end
