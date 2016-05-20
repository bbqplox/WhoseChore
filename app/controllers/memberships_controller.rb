class MembershipsController < ApplicationController

  def show
  end

  private
  def membership_params
      params.require(:membership).permit(:group, :user)
  end

end
