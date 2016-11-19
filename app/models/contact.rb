# Class name: Contact
# Date 2016/10
# @reference  https://rubyonrailshelp.wordpress.com/2014/01/08/rails-4-simple-form-and-mail-form-to-make-contact-form/

class Contact < MailForm::Base
### Validation of attributes ###
  attribute :name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message
  attribute :nickname,  :captcha  => true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "RemindMail New Message",
      :to => "a.kuriackovskij@gmail.com",
      :from => %("#{name}" <#{email}>)
    }
  end
end