########################################################################################
#==                                 Users controller                                ==#
########################################################################################

class UsersController < ApplicationController
    
    before_filter :authenticate_user! # Non-authenticated users can only see list of users
    before_filter :isadmin, :only => [:edit, :destroy, :index] # Admins can edit, destroy and see list of users
    before_action :set_user, only: [:show, :edit, :update, :destroy] #Actions which are allowed to perform against user
    
    #Logic which checks if user is admin and allows to perform certain actions
    def isadmin
        unless current_user && current_user.admin?
        render :forbidden
        end
    end
    
    #Show selected user
    def show
        @user = User.find(params[:id])
    end
    
    #List all users
    def index 
        @users = User.all
    end
    
    #Destroy user method
    def destroy
    @user.destroy
        respond_to do |format|
            format.html { redirect_to users_url, notice: 'User was deleted.' }
            format.json { head :no_content }
        end
    end
    
    #Update user details method
    def update
        respond_to do |format|
            if @user.update(user_params)
                format.html { redirect_to @user, notice: 'Account was successfully updated.' }
                format.json { render :show, status: :ok, location: @user }
            else
                format.html { render :show }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end
    
    
    private
        #Setting a user to make an action against
        def set_user
            @user = User.find(params[:id])
        end
        
        #Settings user params for update method
        def user_params
            params.require(:user).permit(:email, :password, :admin)
        end
end