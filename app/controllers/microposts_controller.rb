#With the code in Listing 10.24, the signed_in_user method is now avail- able in the Microposts controller, which means that we can restrict access to the create and destroy actions with the before filter shown in Listing 10.25. (Since we didn’t generate it at the command line, you will have to create the Microposts controller file by hand.)
#Pg. 544

class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]  #Restricting access to the create and destroy actions with a before filter 
  before_action :correct_user, only: :destroy


  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end 

  private

    #pg.547 
    def micropost_params
      params.require(:micropost).permit(:content)
    end

    #Pg. 568
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end