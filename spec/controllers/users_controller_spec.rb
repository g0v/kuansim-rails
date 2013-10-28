require 'spec_helper'

describe UsersController do

  it "should render login page" do
    get :login
  end
end
