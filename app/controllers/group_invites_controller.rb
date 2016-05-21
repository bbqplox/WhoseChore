class GroupInvitesController < ApplicationController
  before_action :set_group_invite, only: [:destroy]

  def index
    @group_invites = GroupInvite.search_by_user(current_user.id)
  end

  def create

    @user = User.search_by_email(params[:search]).first

    # TO never DO
    @group_invite = GroupInvite.new(user_id: @user.id, group_id: params[:group_id], sender_id: params[:sender_id] )

    respond_to do |format|
      if @group_invite.save
        format.html { redirect_to group_url(params[:group_id]), notice: 'Invite Sent.' }
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

end
