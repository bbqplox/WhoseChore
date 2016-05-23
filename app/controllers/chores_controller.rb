class ChoresController < ApplicationController
  before_action :set_chore, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:index, :show]

  def index
    @chores = Chore.all
  end

  def show
  end

  def new
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @users = @group.users
    end
    @chore = Chore.new
  end

  def edit
  end

  def create
    @chore = Chore.new(chore_params)

    @chore.save
    Chore.remind(@chore.id)

    # TODO: Create chore rotation assignments if rotation if there is a repeat
    if Integer(params[:chore][:repeat_days]) > 0
      ChoreRotation.assign_rotation(@chore.id, @chore.group_id, @chore.user_id)
    end

    redirect_to edit_chore_path(@chore.id), notice: 'Chore was successfully created.'

  end

  def update
    respond_to do |format|
      if @chore.update(chore_params)
        format.html { redirect_to edit_chore_path, notice: 'Chore was successfully updated.' }
        format.json { render :show, status: :ok, location: @chore }
      else
        format.html { render :edit }
        format.json { render json: @chore.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chores/1
  # DELETE /chores/1.json
  def destroy
    @chore.destroy
    respond_to do |format|
      format.html { redirect_to params[:from], notice: 'Chore was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_all_completed
    Chore.destroy_all_completed(params[:user_id])
    respond_to do |format|
      format.html { redirect_to chores_url, notice: 'Chore was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def completion
    @chore = Chore.find(params[:id])
    @membership = Membership.search(@chore.user_id, @chore.group_id).first

    @chore.update_attribute(:complete, true)
    @membership.update_attribute(:chore_score, @membership.chore_score + @chore.score)

    @membership.save
    respond_to do |format|
      format.html { redirect_to params[:from], notice: 'Chore completed' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chore
      @chore = Chore.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chore_params
      params.require(:chore).permit(:user_id, :name, :description, :date, :group_id, :complete, :score, :repeat_days)
    end
end
