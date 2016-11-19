# Class name: RemindsController
# Version: 1.1
# Date 2016/11
# @author Aleksandr Kuriackovskij, x15029476

class RemindsController < ApplicationController

  before_action :set_remind, only: [:show, :edit, :update, :destroy]
  before_filter :set_timezone

  # GET /reminds
  # GET /reminds.json
  def index
    email_id = Email.find_by_email(current_user.email).id
    @reminds = Remind.where(:email => email_id)
  end

  #The same as index method, but is required for listing past reminders
  def completed
    email_id = Email.find_by_email(current_user.email).id
    @reminds = Remind.where(:email => email_id)
  end
  
  #Setting time zone when any actions in this controller occurs 
  def set_timezone
    tz = Profile.find_by_user_id(current_user.id).timezone
    @timezone = Time.now.in_time_zone(tz).strftime('%z')
    if current_user
      User.current = current_user
    end
  end

  # GET /reminds/1
  # GET /reminds/1.json
  def show
  end

  # GET /reminds/new
  def new
    @remind = Remind.new
    @remind.email_id = Email.find_by_email(current_user.email).id #maps reminder to email ID
  end

  # GET /reminds/1/edit
  def edit
  end

  # POST /reminds
  # POST /reminds.json
  def create
      @remind = Remind.new(remind_params)
      if user_signed_in?
	    #Set time zone for new reminder only if user is logged in. There is another method in Remind class for logging from e-mails.
        user_time = @remind.schedule.to_datetime
        @remind.schedule = user_time.change(:offset => @timezone)
      end

    respond_to do |format|
      if @remind.save
        format.html { redirect_to @remind, notice: 'Reminder was successfully created.' }
        format.json { render :show, status: :created, location: @remind }
      else
        format.html { render :new }
        format.json { render json: @remind.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reminds/1
  # PATCH/PUT /reminds/1.json
  def update
    respond_to do |format|
      if @remind.update(remind_params)
        format.html { redirect_to @remind, notice: 'Reminder was successfully updated.' }
        format.json { render :show, status: :ok, location: @remind }
      else
        format.html { render :edit }
        format.json { render json: @remind.errors, status: :unprocessable_entity }
      end
    end
  end

#Method which delete selected reminders
  def destroy_multiple
    Remind.destroy(params[:reminds])
    respond_to do |format|
      format.html { redirect_to :back, notice:  'Reminder(s) was deleted.' }
      format.json { head :no_content }
    end
  end

  # DELETE /reminds/1
  # DELETE /reminds/1.json
  #def destroy
  #  @remind.destroy
  #  respond_to do |format|
  #    format.html { redirect_to :back, notice: 'Reminder was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_remind
      @remind = Remind.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def remind_params
      params.require(:remind).permit(:email_id, :title, :body, :schedule)
    end
end