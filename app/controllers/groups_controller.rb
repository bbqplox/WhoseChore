class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :require_admin, :add_member, :remove_member]
  before_action :require_user, only: [:index, :show]
  before_action :require_admin, only: [:destroy, :add_member, :remove_member]


  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    # TODO: need to give admin
    @group.users << current_user

    respond_to do |format|
      if @group.save
        Membership.give_user_admin(current_user.id, @group.id)
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
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
    @user = User.search_by_email(params[:search]).first

    if @user != nil
      @membership = Membership.search(@user.id, @group.id).first
    else
      @membership = nil
    end

    @notice = nil
    # user must exist and does not belong in the group
    if @user != nil and  @membership == nil

      @membership = Membership.new(group_id: @group.id, user_id: @user.id)
      @notice = 'Member was successfully added.'

    # membership for the user already exists
    elsif @membership != nil

      @membership.active = true
      @notice = 'Membership activated.'

    # failed
    else
      @notice = 'Failed to add member.'
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
