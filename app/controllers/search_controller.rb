# Class name: SearchController
# Version: 0.3
# Date 2016/10
# @author Aleksandr Kuriackovskij, x15029476

class SearchController < ApplicationController
    before_filter :isadmin, :only => [:list_all_reminders, :list_all_sent_reminders]
   
    #Method which verifies if current user admin and allows to invoke search methods
    def isadmin
        unless current_user && current_user.admin?
            render :forbidden
        end
    end
    
	#Method which returns all reminders, or can be filtered by e-mail address
    def list_all_reminders
        if params[:search].blank?
            @reminders = Remind.all
			#Return all reminders
            render 'reminds/listallreminders'
        else
		    #Pass e-mail argument to an Email search method
            @email = Email.search(params[:search])
			#Assigns array of filtered by e-mail reminders to a global variable
            @reminders = Remind.where(email_id: @email.ids)
            render 'reminds/listallreminders'
			#Returns message to the user if no reminders found
            if @email.blank?
                flash[:notice] = "No reminders found for that user."
            end
        end
    end
    #Method which returns all past reminders, or can be filtered by e-mail address
    def list_all_sent_reminders
        if params[:search].blank?
            @reminders = Remind.all
            render 'reminds/listallsentreminders'
        else
            @email = Email.search(params[:search])
            @reminders = Remind.where(email_id: @email.ids)
            render 'reminds/listallsentreminders'
            if @email.blank?
                flash[:notice] = "No reminders found for that user."
            end
        end
    end
    
end