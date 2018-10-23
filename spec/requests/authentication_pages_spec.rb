require 'spec_helper'

describe "Authentication" do
  
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error') }

      describe "after visiting another page" do
        before { click_link "Home"}
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do 
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_title(user.name) }
      it { should have_link('Users',       href: users_path) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_path(user)) } #Why the fuck isn't this working?
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
    end
  end

  describe "authorization" do  #This is still confusing and should be reviewed further (pg. 458)
    
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      

      #Friendly Forwarding - When users try to access a protected page, they are currently redirected to their profile pages regardless of where they were trying to go. In other words, if a non-logged-in user tries to visit the edit page, after signing in the user will be redirected to /users/1 instead of /users/1/edit. It would be much friendlier to redirect them to their intended destination instead.
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
        end
      end

      #Our initial tests verify that non-signed in users attempting to access either edit or update are simply sent to the signin page
      describe "in the Users controller" do
        
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        #Introduces a way to access a controller action: by issuing the appropriate HTTP request directly, in this case using the patch method to issue a patch request 
        describe "submitting to the update action" do
          before { patch user_path(user) }                          #This issues a PATCH request directly to /users/1, which gets routed to the update action of the Users controller (Table 7.1). This is necessary because there is no way for a browser to visit the update action directly—it can only get there indirectly by submitting the edit form—so Capybara can’t do it either. But visiting the edit page only tests the authorization for the edit action, not for update. As a result, the only way to test the proper authorization for the update action itself is to issue a direct request. (As you might guess, in addition to patch Rails tests support get, post, and delete as well.)
          specify { expect(response).to redirect_to(signin_path) }  #Pg. 460
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('All users') }
        end

      end   
    end



    #users should only be allowed to edit their own information. We can test for this by first signing in as an incorrect user and then hitting the edit and update actions (Listing 9.13).
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url) }
      end

      #Use of patch tests the attempt to update 
      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }  # In addition, because users should never even try to edit another user’s profile, upon detecting unauthorized access we redirect to the root URL rather than to the signin page.
      end 
    end

    #As constructed, only admins can destroy users through the web, because only admins can see the delete links. Unfortunately, there’s still a terrible se- curity hole: any sufficiently sophisticated attacker could simply issue DELETE requests directly from the command line to delete any user on the site. To secure the site properly, we also need access control on the destroy action, so our tests should check not only that admins can delete users, but also that other users can’t. The results appear in Listing 9.45. Note that, in analogy with the patch method from Listing 9.11, we use delete to issue a DELETE request directly to the specified URL (in this case, the user path, as required by Table 7.1). (Pg. 500) 
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }
      before { sign_in non_admin, no_capybara: true }
      
      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end 
    end

    
  end 
end

