class ChoresController < ApplicationController
  before_action :set_chore, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:index, :show]

  # GET /chores
  # GET /chores.json
  def index
    @chores = Chore.all
  end

  # GET /chores/1
  # GET /chores/1.json
  def show
  end

  # GET /chores/new
  def new
    @chore = Chore.new
  end

  # GET /chores/1/edit
  def edit
  end

  # POST /chores
  # POST /chores.json
  def create
    @chore = Chore.new(chore_params)
    current_user.chores << @chore

    respond_to do |format|
      if @chore.save
        format.html { redirect_to edit_chore_path(@chore.id), notice: 'Chore was successfully created.' }
        format.json { render :show, status: :created, location: @chore }
      else
        format.html { render :new }
        format.json { render json: @chore.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chores/1
  # PATCH/PUT /chores/1.json
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
      params.require(:chore).permit(:user_id, :name, :description, :date, :group_id, :complete, :score)
    end
end
