class RemindsController < ApplicationController

  before_action :set_remind, only: [:show, :edit, :update, :destroy]

  # GET /reminds
  # GET /reminds.json
  def index
  email_id = Email.find_by_profile_id(current_user.id).id
  @reminds = Remind.where(:email => email_id)
  end

  def getemail
    emails = Mail.all
  end

  # GET /reminds/1
  # GET /reminds/1.json
  def show
  end

  # GET /reminds/new
  def new
    @profile = current_user.id #getting profile ID
    @remind = Remind.new
    @remind.email_id = @profile #link reservation to profile ID
  end

  # GET /reminds/1/edit
  def edit
  end
  
  def send_email(details)
    recipient = Email.find_by_id(details.email_id).email
    title = details.title
    Mail.deliver do
      to recipient
      from ENV['USER_NAME']
      subject 'Reminder has been logged: '+title
      body 'Thank you for using Reminder Service!'
    end
  end

  # POST /reminds
  # POST /reminds.json
  def create
      @remind = Remind.new(remind_params)

    respond_to do |format|
      if @remind.save && user_signed_in?
        format.html { redirect_to @remind, notice: 'Remind was successfully created.' }
        format.json { render :show, status: :created, location: @remind }
      elsif
        Remind.send_email(@remind)
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
        format.html { redirect_to @remind, notice: 'Remind was successfully updated.' }
        format.json { render :show, status: :ok, location: @remind }
      else
        format.html { render :edit }
        format.json { render json: @remind.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reminds/1
  # DELETE /reminds/1.json
  def destroy
    @remind.destroy
    respond_to do |format|
      format.html { redirect_to reminds_url, notice: 'Remind was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

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
