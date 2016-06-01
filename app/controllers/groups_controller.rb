class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :require_admin, :add_member, :remove_member, :rewards]
  before_action :require_user, only: [:index, :show]
  before_action :require_admin, only: [:destroy, :remove_member]

  def index
    @groups = Group.all
  end

  def show
    @users_search = User.search(params[:search])
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    """
    Create a group with the current user added as an admin by default.
    """
    @group = Group.new(group_params)
    @group.save
    @membership = Membership.new(
      group_id: @group.id, user_id: current_user.id,
      chore_score: 0, active: true, admin: true, group_id: @group.id)

    @membership.save
    redirect_to @group, notice: 'Group was successfully created.'
  end

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end

  end

  def add_member
    """
    Forms mapping between user and group. Reactivates membership if already exists.
    """
    if params[:invite_id]
      @invite = GroupInvite.find(params[:invite_id])
      @invite.destroy
    end

    @user = User.find(params[:user_id])

    if @user != nil
      @membership = Membership.search(params[:user_id], @group.id).first
    else
      @membership = nil
    end

    @notice = nil
    # user must exist and does not belong in the group
    if @user != nil and  @membership == nil

      @membership = Membership.new(group_id: @group.id, user_id: @user.id, chore_score:0)
      @membership.active = true
      @notice = 'Welcome to the group!'

    # membership for the user already exists
    elsif @membership != nil

      @membership.active = true
      @notice = 'Welcome back!'

    # failed
    else
      @notice = 'Failed to add member.'
      redirect_to group_invites_path, notice: @notice
    end

    if @membership != nil
      @membership.save
    end

    ChoreRotation.add_rotation_member(@user.id, @group.id)

    redirect_to @group, notice: @notice
  end

  def remove_member
    """
    Deactivate membership between user and group.
    """
    @user = User.search_by_id(params[:user_id]).first

    @membership = Membership.search(@user.id, @group.id).first

    # membership must already exist
    if @membership != nil
      @membership.active = false
      @notice = 'Member successfuly banished.'
    # failed
    else
      @notice = 'Failed to banish member.'
    end

    if @membership != nil
      @membership.save
    end

    ChoreRotation.remove_rotation_member(@user.id, @group.id)

    redirect_to @group, notice: @notice
  end

  def is_admin
    Membership.search(current_user.id, params[:id]).first.admin
  end

  def require_admin
		redirect_to @group, notice: 'You do not have administrator privileges.' unless is_admin
	end

  def destroy
    @group.destroy
    Membership.disband_group(@group.id)
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  def rewards
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name)

    end
end
