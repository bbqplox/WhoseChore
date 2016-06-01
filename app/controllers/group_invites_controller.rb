class GroupInvitesController < ApplicationController
  before_action :set_group_invite, only: [:destroy]

  def index
    @group_invites = GroupInvite.search_by_user(current_user.id)
  end

  def create
    # TO never DO
    @group_invite = GroupInvite.new(group_invite_params)

    respond_to do |format|
      if @group_invite.save
        format.html { redirect_to group_url(params[:invite][:group_id]), notice: 'Invite Sent.' }
        UserMailer.group_invite_email(User.find(params[:invite][:user_id]), Group.find(params[:invite][:group_id]).name).deliver_later
        format.json { render :show, status: :created, location: @group_invite }
      else
        format.html { render :new }
        format.json { render json: @group_invite.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @group_invite.destroy
    respond_to do |format|
      format.html { redirect_to group_invites_url, notice: 'Invite Declined.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_invite
      @group_invite = GroupInvite.find(params[:id])
    end

    def group_invite_params
  		params.require(:invite).permit(:user_id, :sender_id, :group_id)
  	end

end
