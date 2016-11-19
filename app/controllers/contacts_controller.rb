# Class name: ContactsController
# Date 2016/10
# @ reference https://rubyonrailshelp.wordpress.com/2014/01/08/rails-4-simple-form-and-mail-form-to-make-contact-form/
class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end
  #Contact us creation
  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    ### Displaying appropriate message after message has bene submitted. ###
    if @contact.deliver
      flash.now[:notice] = 'Thank you for contacting us. RemindMail team will get in touch with you soon!'
    else
      flash.now[:error] = 'Sorry, but we cannot accept your message.'
      render :new
    end
  end
end