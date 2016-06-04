class RewardsController < ApplicationController
  before_action :set_reward, only: [:show, :edit, :update, :destroy]

  # GET /rewards
  # GET /rewards.json
  def index
    @rewards = Reward.all
  end

  # GET /rewards/1
  # GET /rewards/1.json
  def show
  end

  # GET /rewards/new
  def new
    if params[:group_id]
      @group = Group.find(params[:group_id])
    end
    @reward = Reward.new
  end

  # GET /rewards/1/edit
  def edit
  end

  # POST /rewards
  # POST /rewards.json
  def create
    @reward = Reward.new(reward_params)

    respond_to do |format|
      if @reward.save
        @group = Group.find(@reward.group_id)
        format.html { redirect_to group_rewards_path(@group.id), notice: 'Reward was successfully created.' }
        format.json { render :show, status: :created, location: @reward }
      else
        format.html { render :new }
        format.json { render json: @reward.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rewards/1
  # PATCH/PUT /rewards/1.json
  def update
    respond_to do |format|
      if @reward.update(reward_params)
        @group = Group.find(@reward.group_id)
        format.html { redirect_to group_rewards_path(@group.id), notice: 'Reward was successfully updated.' }
        format.json { render :show, status: :ok, location: @reward }
      else
        format.html { render :edit }
        format.json { render json: @reward.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rewards/1
  # DELETE /rewards/1.json
  def destroy
    @group = Group.find(@reward.group_id)
    @reward.destroy
    respond_to do |format|
      format.html { redirect_to group_rewards_path(@group.id), notice: 'Reward was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def purchase
    @reward = Reward.find(params[:id])
    @membership = Membership.search(current_user.id, @reward.group_id).first
    @notice = 'Not enough Chore Score'

    if @reward.cost <= @membership.chore_score
      @reward.update_attribute(:claimed_time, Date.today)
      @reward.update_attribute(:user_id, current_user.id)
      @reward.save
      @membership.update_attribute(:chore_score, @membership.chore_score - @reward.cost)
      @membership.save
      @notice = 'Reward purchased'
    end

    respond_to do |format|
      format.html { redirect_to :back, notice: @notice }
      format.json { head :no_content }
    end

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reward
      @reward = Reward.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reward_params
      params.require(:reward).permit(:name, :description, :cost, :group_id, :user_id, :claimed_time)
    end
end
