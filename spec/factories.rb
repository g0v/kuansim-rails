FactoryGirl.define do
  factory :user do
    email "wohf@gmail.com"
    password "secretpassword"
    events {
      [FactoryGirl.create(:event)]
    }
  end

  factory :event do

  end
end