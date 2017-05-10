class ContactsController < ApplicationController

  #GET request to /contact-us and show new form
  def new
    @contact = Contact.new
  end

  #POST request /contact_params
  def create
    #Mass assignment of form fields into contact object
    @contact = Contact.new(contact_params)

    #save contact object to db
    if @contact.save

      #local vars of form fields via parameters
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]

      #plug vars into Contact Mailer email method and send mail
      ContactMailer.contact_email(name, email, body).deliver
      #store success msg
      flash[:success] = "Message sent"
      #redirect to new_contact_path (contact-us)
      redirect_to new_contact_path
    else
      #if it doesnt save to db, store error in flash hash
      flash[:danger] = @contact.errors.full_messages.join(", ")
      #redirect to new_contact_path (contact-us)
      redirect_to new_contact_path
    end

  end

  private
  #to collect data from forms, we need to use strong parameters and whitelist
  # form fields
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end

end
