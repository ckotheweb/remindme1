# Class name: EmailsController
# Version: 0.3
# Date 2016/10
# @author Aleksandr Kuriackovskij, x15029476
class EmailsController < ApplicationController

before_action :set_email, only: [:update, :destroy]
before_filter :authenticate_user!
before_filter :dont_allow, :only => [:index, :show, :new, :edit]

 #Method which prevents from any users actions related to "emails" CRUD
  def dont_allow
    render :forbidden
  end

  # GET /emails
  # GET /emails.json
  def index
    @emails = Mail.all
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
  end

  # GET /emails/new
  def new
    @email = Email.new
  end

  # GET /emails/1/edit
  def edit
  end

  # POST /emails
  # POST /emails.json
  def create
    @email = Email.new(email_params)

  end

  # PATCH/PUT /emails/1
  # PATCH/PUT /emails/1.json
  def update
    respond_to do |format|
      if @email.update(email_params)
        format.html { redirect_to @email, notice: 'Email was successfully updated.' }
        format.json { render :show, status: :ok, location: @email }
      else
        format.html { render :edit }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email.destroy
    respond_to do |format|
      format.html { redirect_to emails_url, notice: 'Email was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_params
      params.require(:email).permit(:email, :profile_id)
    end
end
