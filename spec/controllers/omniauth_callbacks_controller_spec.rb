require 'spec_helper'
describe "Authentications" do
  context "Clicking the login link" do
    it "Login button should log in" do
      get :new
      click_link "Login"
      page.should have_text "google"
    end
  end
end

