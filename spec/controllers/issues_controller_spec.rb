require 'spec_helper'

describe IssuesController do
  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @fake_data = {"issue" => {
                    "title" => 'Bart Strike',
                    "description" => "Renegotiating employee contract."}}
    @fake_mod_data = {"title" => 'Bart Strike',
                     "description" => "Renegotiating employee contract."}
    @issue = FactoryGirl.create(:issue)
  end

  describe 'create' do
    it 'should create a new issue' do
      Issue.should_receive(:create).with(@fake_mod_data)
      post :create, @fake_data
    end

    it 'should not create a new issue if no params are supplied' do
      Issue.should_not_receive(:create)
      post :create
    end
  end

  describe 'delete' do
    it 'should delete the selected issue' do
      Issue.should_receive(:delete)
      delete :delete, {:id => @issue.id}
    end
  end

  describe 'update' do
    before :each do
      user = FactoryGirl.create(:user)
      sign_in user
      controller.current_user.stub(:has_issue?).and_return(true)
    end
    
    it 'should update the selected issue' do
      @fake_data["id"] = @issue.id
      Issue.stub(:find) {@issue}
      Issue.should_receive(:find)
      @issue.should_receive(:update_attributes).with(@fake_mod_data)
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
      load "#{Rails.root}/db/seeds.rb"
      id = Issue.find_by_title("Issue 0").id
      get :timeline, id: id
      response.body.should have_content("Issue 0")
    end
  end

  describe 'listing all issues' do
    before :each do
      first = mock(Issue)
      first.stub(:id).and_return('1')
      first.stub(:title).and_return('first issue title')
      first.stub(:description).and_return('issue description')

      second = mock(Issue)
      second.stub(:id).and_return('2')
      second.stub(:title).and_return('second issue title')
      second.stub(:description).and_return('issue description2')

      issues = [first, second]

      Issue.stub(:find).and_return(issues)
    end


    it 'lists all the issues' do
      get :list_all_issues
      response.body.should have_content("1")
      response.body.should have_content("2")
      response.body.should have_content("first issue title")
      response.body.should have_content("second issue title")
      response.body.should have_content("issue description2")
    end



  end

  describe 'listing all issues' do
    before :each do
      first = mock(Issue)
      first.stub(:id).and_return('1')
      first.stub(:title).and_return('first issue title')
      first.stub(:description).and_return('issue description')

      second = mock(Issue)
      second.stub(:id).and_return('2')
      second.stub(:title).and_return('second issue title')
      second.stub(:description).and_return('issue description2')

      issues = [first, second]

      Issue.stub(:find).and_return(issues)
    end


    it 'lists all the issues' do
      get :list_all_issues
      response.body.should have_content("1")
      response.body.should have_content("2")
      response.body.should have_content("first issue title")
      response.body.should have_content("second issue title")
      response.body.should have_content("issue description2")
    end

  end

  describe "related issues" do

    before :each do
      @bart = Issue.create(
        title: 'Bart Strike',
        description: 'Workers want more stuff'
        )
      @drinking = Issue.create(
        title: 'College Drinking',
        description: 'Increased drinking in college'
        )
      @malaysia = Issue.create(
        title: 'Strike in Malaysia',
        description: 'Rice farmers want more shit'
        )
      bart_event = FactoryGirl.build(:bart_event)
      drink_event = FactoryGirl.build(:freshmen_drink)
      malaysia_event = FactoryGirl.build(:malaysia_event)
      [bart_event, malaysia_event].each do |event|
        event.issues << @bart
        event.issues << @malaysia
      end
      drink_event.issues << @drinking
      [bart_event, drink_event, malaysia_event].each {|event| event.save }
    end

    it "should be successfully found and displayed" do
      get :related, {id: @bart.id}
      response.body.should have_content "Strike in Malaysia"
    end

    it "should not display issues that have 0 events in common" do
      get :related, {id: @drinking}
      response.body.should have_content "\"related\":[]"
    end

  end

end