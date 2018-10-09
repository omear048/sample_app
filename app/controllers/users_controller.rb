class UsersController < ApplicationController
  def show   #When Rails’ REST features are activated, GET requests are automatically handled by the show action
    @user = User.find(params[:id])  #Here we’ve used params to retrieve the user id. When we make the appropriate request to the Users controller, params[:id] will be the user id 1, so the effect is the same as the find method User.find(1) Technically, params[:id] is the string "1", but find is smart enough to convert this to an integer.
  end


  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private 

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
  end
end
