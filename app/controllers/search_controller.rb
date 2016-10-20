class SearchController < ApplicationController
    before_filter :isadmin, :only => [:list_all_reminders, :list_all_sent_reminders]
   
    #Method which verifies if current user admin and allows to invoke search methods
    def isadmin
        unless current_user && current_user.admin?
            render :forbidden
        end
    end
    
    def list_all_reminders
        if params[:search].blank?
            @reminders = Remind.all
            render 'reminds/listallreminders'
        else
            @email = Email.search(params[:search])
            @reminders = Remind.where(email_id: @email.ids)
            render 'reminds/listallreminders'
            if @email.blank?
                flash[:notice] = "No reminders found for that user."
            end
        end
    end
    
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