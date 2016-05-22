class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :require_admin, :add_member, :remove_member]
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
    @group = Group.new(group_params)
    # TODO: need to give admin
    @group.users << current_user

    respond_to do |format|
      if @group.save
        #Membership.give_user_admin(current_user.id, @group.id)
        @membership = Membership.search(current_user.id, @group.id).first
        @membership.chore_score = 0
        @membership.admin = true
        @membership.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
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

    redirect_to @group, notice: @notice
  end

  def remove_member
    """
    Deactivate membership between user and group.
    """
    @user = User.search_by_id(params[:user_id]).first
    #@group = Group.find(params[:id])
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
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
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
