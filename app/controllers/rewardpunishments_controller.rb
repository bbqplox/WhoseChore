class RewardpunishmentsController < ApplicationController
  before_action :find_rewardpunishment, only: [:show, :edit, :update, :destroy]
  def index
    @rewardpunishments = Rewardpunishment.all.order(:rorp)
  end

  def new
    @rewardpunishment = Rewardpunishment.new
  end

  def create
    @rewardpunishment = Rewardpunishment.new(rewardpunishment_params)

    if @rewardpunishment.save
      redirect_to @rewardpunishment
    else
      render 'new'
    end
  end

  def show

  end

  def edit
  end

  def update
    if @rewardpunishment.update(rewardpunishment_params)
      redirect_to @rewardpunishment
    else
      render 'edit'
    end
  end

  def destroy
    @rewardpunishment.destroy
    redirect_to rewardpunishments_url
  end

  private

  def find_rewardpunishment
    @rewardpunishment = Rewardpunishment.find(params[:id])
  end

  def rewardpunishment_params
    params.require(:rewardpunishment).permit(:title, :description, :value, :rorp)
  end
end
