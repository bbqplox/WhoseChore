class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update, :destroy]

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
		redirect_to @user.profile
	end

	def index
  		@users = User.search_index(params[:search])
	end

	private
	def set_user
      @user = User.find(params[:id])
    end

	def user_params
		params.require(:user).permit(:first_name, :last_name, :email, :password)
	end



end
