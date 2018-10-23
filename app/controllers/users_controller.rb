class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]  #To require users to be signed in, we define a signed_in_user method and invoke it using before_action :signed_in_user #Why the fuck does this break the spec tests?    #Keeps user from using a patch to change data
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy           #In principle, there’s still a minor security hole, which is that an admin could delete himself by issuing a DELETE request directly. As you might suspect by now, the application code uses a before filter, this time to restrict access to the destroy action to admins. The resulting admin_user before filter appears in Listing 9.46. (Pg. 501) 

  def index
    #@users = User.all (*Used to be this, but changed to allow for pagination )
    @users = User.paginate(page: params[:page])  #.paginate method must be added to the end to allow for only 30 users to show-up on a page 
  end


  def show   #When Rails’ REST features are activated, GET requests are automatically handled by the show action
    @user = User.find(params[:id])  #Here we’ve used params to retrieve the user id. When we make the appropriate request to the Users controller, params[:id] will be the user id 1, so the effect is the same as the find method User.find(1) Technically, params[:id] is the string "1", but find is smart enough to convert this to an integer.
  end


  def new
    @user = User.new #The application code uses User.all to pull all the users out of the database
  end

  def create #This stems from a post and will never have a web page 
    @user = User.new(user_params)  #Uses the new method found right above 

    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit 
    #@user = User.find(params[:id])  --Now that the correct_user before filter defines @user, we can omit it from both actions.
  end

  def update
    #@user = User.find(params[:id])  --Taken out once the :signed_in_user & :correct_user added (pg. 465)
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else 
      render 'edit'
    end
  end

  #To get the delete links to work, we need to add a destroy action (Ta- ble 7.1), which finds the corresponding user and destroys it with the Active Record destroy method, finally redirecting to the user index, as seen in List- ing 9.44. Note that we also add :destroy to the signed_in_user before filter.(Pg. 498) 
  def destroy  
    User.find(params[:id]).destroy     #Note that the destroy action uses method chaining to combine the find and destroy into one line
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private 

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
  end

  #Before filters

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in." 
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end














