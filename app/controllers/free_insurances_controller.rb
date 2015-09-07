# encoding: utf-8

class FreeInsurancesController < ApplicationController
  before_action :set_free_insurance, only: [:show, :edit, :update, :destroy]

  # GET /free_insurances
  # GET /free_insurances.json
  def index
    @free_insurances = FreeInsurance.all
  end

  # GET /free_insurances/1
  # GET /free_insurances/1.json
  def show
  end

  # GET /free_insurances/new
  def new
    @free_insurance = FreeInsurance.new
  end

  # GET /free_insurances/1/edit
  def edit
  end

  # POST /free_insurances
  # POST /free_insurances.json
  def create
    @free_insurance = FreeInsurance.new(free_insurance_params)
    @free_insurance.accepted = true
    @free_insurance.province = "成都市"
    @free_insurance.city = "成都市"
    @free_insurance.address = "成都市"
    @free_insurance.id_type = "IdentityCard"
    @free_insurance.save
    begin
      response = FreeInsurance.send_to_metlife(@free_insurance)  # Try to send the data to MetLife.
      
      if response
        @free_insurance.processed = true if response.hash == "承保成功"
      else
        @free_insurance.processed = false
      end
    rescue
      @free_insurance.processed = false
    end

    respond_to do |format|
      if @free_insurance.save
        format.html { redirect_to @free_insurance, notice: '您的免费保险申请已经成功记录' }
        format.json { render :show, status: :created, location: @free_insurance }
      else
        format.html { render :new }
        format.json { render json: @free_insurance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /free_insurances/1
  # PATCH/PUT /free_insurances/1.json
  def update
    respond_to do |format|
      if @free_insurance.update(free_insurance_params)
        format.html { redirect_to @free_insurance, notice: 'Free insurance was successfully updated.' }
        format.json { render :show, status: :ok, location: @free_insurance }
      else
        format.html { render :edit }
        format.json { render json: @free_insurance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /free_insurances/1
  # DELETE /free_insurances/1.json
  def destroy
    @free_insurance.destroy
    respond_to do |format|
      format.html { redirect_to free_insurances_url, notice: 'Free insurance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # As the root page of the free insurance, which show the search form.
  def search_page_of

  end

  # To search the free insurace with user's name and mobile.
  def search_result_of
    result = FreeInsurance.search(params[:user], params[:mobile])
    @free_insurance = result.first
    if @free_insurance.blank?
      redirect_to :back, alert: "查无此单。请确认姓名与手机是否准确。"
    else
      @free_insurance
    end
  end

  def validate_user_of

  end

  def validate_result_of
    result = FreeInsurance.search(params[:user], params[:mobile])
    @free_insurance = result.first
    if @free_insurance.blank?
      redirect_to :new_free_insurance, alert: "查无此单。请确认您输入的信息，或者选择新建您的订单记录。"
    else # Make sure there are other logics here.
      @free_insurance
    end
  end

  def all_terms
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_free_insurance
      @free_insurance = FreeInsurance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def free_insurance_params
      params.require(:free_insurance).permit(:user, :mobile, :birthday, :processed, :accepted, :email,
                                             :id_num, :id_type, :gender, :accepted_all_terms,
                                             :processed, :province, :city, :address, :activated)
    end
end
