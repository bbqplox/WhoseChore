class ProfileController < ApplicationController

def edit
	@user = User.find(session[:user_id])
end

def show
	@user = User.find(current_user.id)
end

end
