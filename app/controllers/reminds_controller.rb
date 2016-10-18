class RemindsController < ApplicationController

  before_action :set_remind, only: [:show, :edit, :update, :destroy]

  # GET /reminds
  # GET /reminds.json
  def index
  email_id = Email.find_by_email(current_user.email).id
  @reminds = Remind.where(:email => email_id)
  end

  # GET /reminds/1
  # GET /reminds/1.json
  def show
  end

  # GET /reminds/new
  def new
    @remind = Remind.new
    @remind.email_id = Email.find_by_email(current_user.email).id #link reservation to profile ID
  end

  # GET /reminds/1/edit
  def edit
  end

  # POST /reminds
  # POST /reminds.json
  def create
      @remind = Remind.new(remind_params)

    respond_to do |format|
      if @remind.save
        format.html { redirect_to @remind, notice: 'Remind was successfully created.' }
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
