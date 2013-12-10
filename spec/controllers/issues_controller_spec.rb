require 'spec_helper'

describe IssuesController do
  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @fake_data = {"issue" => {
                    "title" => 'Obamacare',
                    "description" => "Obama's landmark healthcare bill."}}
    @issue = FactoryGirl.create(:issue)
    @user.issues << @issue

    @bart = FactoryGirl.create(:bart_strike_issue)
    @drinking = FactoryGirl.create(:drinking_issue)
    @malaysia = FactoryGirl.create(:malaysia_strike_issue)
    @bart_event = FactoryGirl.build(:bart_event)
    @drink_event = FactoryGirl.build(:freshmen_drink)
    @malaysia_event = FactoryGirl.build(:malaysia_event)
  end

  describe 'create' do
    it 'should create a new issue' do
      post :create, {"issue" => {"title" => 'NSA Spying', "description" => 'NSA Spying Scandal'}}
      response.body.should have_content "true"
    end

    it 'should not create a new issue if validation is failed' do
      post :create
      response.body.should have_content "false"
    end
  end

  describe 'delete' do
    it 'should delete the selected issue' do
      controller.current_user.stub(:has_issue?).and_return true
      Issue.should_receive(:destroy)
      delete :destroy, {:id => @issue.id}
    end
  end

  describe 'update' do
    before :each do
      controller.current_user.stub(:has_issue?).and_return(true)
    end

    it 'should update the selected issue' do
      @fake_data["id"] = @issue.id
      Issue.stub(:find) {@issue}
      Issue.should_receive(:find)
      @issue.should_receive(:update_attributes).with(@fake_data["issue"])
      put :update, @fake_data
    end

    it 'should not update a new issue if the issue does not exist' do
      Issue.stub(:find) {nil}
      @issue.should_not_receive(:update_attributes)
      @fake_data["id"] = 123
      put :update, @fake_data
    end
  end

  describe 'timeline' do
    before :each do
    end

    it "should successfully return data json for given issue" do
      title = @issue.title
      @issue.events << FactoryGirl.create(:event)
      get :timeline, id: title
      response.body.should have_content(title)
    end
  end

  describe 'listing all issues' do
    before :each do
      issues = [@bart, @drinking]
      Issue.stub(:all).and_return(issues)
    end

    it 'lists all the issues' do
      get :index
      response.body.should have_content(@bart.title)
      response.body.should have_content(@drinking.title)
      response.body.should have_content("true")
    end
  end

  describe "popular" do

    before :each do
      [@bart_event, @malaysia_event].each do |event|
        @bart.events << event
      end
      @malaysia.events << @malaysia_event
    end

    it "should correctly return the issues with the most events" do
      get :popular
      response.body.should have_content "Bart Strike"
      response.body.should have_content "Strike in Malaysia"
      response.body.should_not have_content "College Drinking"
    end

  end

end