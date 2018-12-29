require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path } #visit '/static_pages/home'
    
    it { should have_content('Sample App') }
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      #To test the display of the status feed, we first create a couple of microp- osts and then verify that a list element (li) appears on the page for each one (Listing 10.37). (Pg. 559)
      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end 

      describe "for signed-in users" do 
        let(:user) { FactoryGirl.create(:user) }
        before do 
          FactoryGirl.create(:micropost, user: user, content: "Lorem")
          FactoryGirl.create(:micropost, user: user, content: "Ipsum")
          sign_in user
          visit root_path
        end

        it "should render the user's feed" do 
          user.feed.each do |item|
            expect(page).to have_selector("li##{item.id}", text: item.content)
          end
        end

        describe "follower/following counts" do 
          let(:other_user) { FactoryGirl.create(:user) }
          before do 
            other_user.follow!(user)
            visit root_path
          end

          it { should have_link("0 following", href: following_user_path(user)) }
          it { should have_link("1 followers", href: followers_user_path(user)) }
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }  #visit '/static_pages/help'

    it { should have_content('Help') }
    it { should have_title (full_title('Help')) }
  end

 describe "About page" do
    before {visit about_path} #visit '/static_pages/about'

    it { should have_content('About') }
    it { should have_title(full_title('About Us')) }    
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_selector('h1', text: 'Contact') }
    it { should have_title(full_title('Contact')) }
  end



end


























