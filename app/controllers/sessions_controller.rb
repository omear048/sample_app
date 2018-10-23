class SessionsController < ApplicationController

  def new
    
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase) #Pulls the user out of the dtabase using the submitted email addredd (pg. 400)
    if user && user.authenticate(params[:session][:password])  #This uses && (logical and) to determine if the resulting user is valid. Taking into account that any object other than nil and false itself is true in a boolean context (Section 4.2.3), the possibilities appear as in Table 8.2. We see from Table 8.2 that the if statement is true only if a user with the given email both exists in the database and has the given password, exactly as required.
      sign_in user        
      redirect_back_or user   #This evaluates to session[:return_to] unless it’s nil, in which case it evaluates to the given user default URL. 
    else
      flash.now[:error] = 'Invalid email/password combination' # nstead of flash we use flash.now, which is specifically designed for displaying flash messages on rendered pages; unlike the contents of flash, its contents disappear as soon as there is an additional request. The corrected application code appears in Listing 8.12.
      render 'new'
    end
  end

  def destroy 
    sign_out
    redirect_to root_url
  end

end
