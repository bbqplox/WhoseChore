class MembershipsController < ApplicationController
​
  def revoke
    #@membership.destroy
    #respond_to do |format|
      #format.html { redirect_to groups_url, notice: 'Membership was revoked.' }
      #format.json { head :no_content }
    #end
  end
​
  private
    def group_params
      params.require(:membership).permit(:group, :user)
    end

end
