class ChoreRequestsController < ApplicationController
  before_action :set_chore_request, only: [:destroy]

  def index
    @chore_requests = ChoreRequest.search_by_user(current_user.id)
  end

  def create
    @chore_request = ChoreRequest.new(chore_requests_params)

    respond_to do |format|
      if @chore_request.save
        format.html { redirect_to chore_url(params[:request][:chore_id]), notice: 'Request Sent.' }
        format.json { render :show, status: :created, location: @chore_request }
      else
        format.html { render :new }
        format.json { render json: @chore_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @chore_request.destroy
    respond_to do |format|
      format.html { redirect_to chore_requests_url, notice: 'Request Declined.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chore_request
      @chore_request = ChoreRequest.find(params[:id])
    end

    def chore_requests_params
  		params.require(:request).permit(:user_id, :sender_id, :chore_id)
  	end
end
