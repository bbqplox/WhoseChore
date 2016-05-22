class MembershipsController < ApplicationController

  def show
  end

  private
  def membership_params
      params.require(:membership).permit(:group_id, :user_id, :chore_score)
  end

end
