class MembershipsController < ApplicationController
#defrevoke
#@membership.destroy
#respond_to do |format|
#format.html{redirect_to groups_url,notice:'Membership was revoked.'}
#format.json{head:no_content}
#end
#end

  def create

    @user = User.search(params[:search]).first
    @group = Group.find(params[:group])
    if @user != nil and Membership.search(@user.id, @group.id).first == nil

      @membership = Membership.new(group_id: @group.id, user_id: @user.id)

      respond_to do |format|
        if @membership.save
          format.html { redirect_to @group, notice: 'Member successfully added.' }
          format.json { render :show, status: :created, location: @group }
        else
          format.html { render :new }
          format.json { render json: @group.errors, status: :unprocessable_entity }
        end
      end

    else
      redirect_to @group, notice: 'Failed to add member.'
    end

  end

  private
  def membership_params
      params.require(:membership).permit(:group, :user)
  end

end
