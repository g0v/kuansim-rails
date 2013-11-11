require 'spec_helper'

describe IssuesController do

  before :each do
  end

  it "should successfully return data json for given issue" do
    load "#{Rails.root}/db/seeds.rb"
    id = Issue.find_by_title("Issue 0")
    get :timeline, issue_id: id
    response.body.should have_content("Issue 0")
    response.body.should have_content("Jerry's drinking problem.")
    response.body.should have_content("Group Meeting Binge Drinking")
    response.body.should have_content("5 Beers!")
    response.body.should have_content("#InsufficientAlcohol")
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

end