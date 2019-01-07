module SessionsHelper #Available automatically to all views, but had to be added as a mixin module to the application+controller 


  def sign_in(user)
    remember_token = User.new_remember_token                #first, create a new token
    cookies.permanent[:remember_token] = remember_token     #second, place the raw token in the browser cookies
    user.update_attribute(:remember_token, User.digest(remember_token)) #third, save the hashed token to the database #update_attribute method allows us to update a single attribute while bypassing the validations 
    self.current_user = user                #fourth, set the current user equal to the given user
  end

  def signed_in?
    !current_user.nil? #current_user is not nil (bang operator) 
  end

  #
  def current_user=(user)
    @current_user = user
  end

  def current_user  #[Pg. 421]
    remember_token = User.digest(cookies[:remember_token])  #Note that, because the remember token in the database is hashed, we first need to hash the token from the cookie before using it to find the user in the database. We accomplish this with the User.digest method defined in Listing 8.18.
    @current_user ||= User.find_by(remember_token: remember_token)  #Its effect is to set the @current_user instance variable to the user corresponding to the remember token, but only if @current_user is undefined.7 # In other words, the construction calls the find_by method the first time current_user is called, but on sub- sequent invocations returns @current_user without hitting the database.8 This is only useful if current_user is used more than once for a single user request; in any case, find_by will be called at least once every time a user visits a page on the site.
  end           # ||= ("or equals") [pg. 421]

  def current_user?(user)
    user==current_user
  end

  #Moved here from the users_controller.rb since this method will be used by the users_controller.rb & microposts_controller.rb
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end


  #Friendly Forwarding - In order to forward users to their intended destination, we need to store the location of the requested page somewhere, and then redirect to that location instead. We accomplish this with a pair of methods, store_location and redirect_back_or, both defined in the Sessions helper (Listing 9.17). [Pg. 469]
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)   #To implement the forwarding itself, we use the redirect_back_or method to redirect to the requested URL if it exists, or some default URL otherwise, which we add to the Sessions controller create action to redirect after suc- cessful signin (Listing 9.19).
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

end
 
