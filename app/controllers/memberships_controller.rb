class MembershipsController < ApplicationController

  def create
    """
    Forms mapping between user and group. Reactivates membership if already exists.
    """
    @user = User.search_by_email(params[:search]).first
    @group = Group.find(params[:group])

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
      #redirect_to @group, notice: 'Failed to add member.'
      @notice = 'Failed to add member.'
    end

    if @membership != nil
      @membership.save
    end

    redirect_to @group, notice: @notice

  end


  def deactivate
    """
    Deactivate membership between user and group.
    """
    @user = User.search_by_id(params[:user]).first
    @group = Group.find(params[:group])
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

  private
  def membership_params
      params.require(:membership).permit(:group, :user)
  end

end
