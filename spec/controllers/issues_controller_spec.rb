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

end