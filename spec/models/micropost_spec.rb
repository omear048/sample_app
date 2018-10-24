require 'spec_helper'

describe Micropost do 

  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }  #The subject block is only executed once per example, the result of which is cached and returned by any subsequent calls to subject.

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user } 

  it { should be_valid }

  #As shown in Listing 10.3, the validation test for user id just sets the id to nil and then checks that the resulting micropost is invalid.
  describe "when user_id is not present" do 
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

end
