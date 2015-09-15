class PreordersController < ApplicationController
  before_action :set_preorder, only: [:show, :edit, :update, :destroy]

  def validate_user_of

  end

  def validate_result_of
    result = Preorder.search(params[:user], params[:mobile])
    @preorder = result.first
    if @preorder.blank?
      session[:user] = params[:user]
      session[:mobile] = params[:mobile]

      redirect_to new_free_insurance_path, alert: "未查到您的记录，请完善您的详细信息。"
    else # Make sure there are other logics here.
      session[:po_id] = @preorder.id
      @preorder
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_preorder
      @preorder = Preorder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def preorder_params
      params.require(:preorder).permit(:user, :mobile, :id_num, :gender,
                                       :remarks, :used)
    end
end
