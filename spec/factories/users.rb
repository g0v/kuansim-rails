FactoryGirl.define do

  factory :user do
    name "Test Guy"
    email "dont@mail.me"
    password "gaayyyyyyyyyaayaya"
    provider "google"
    uid "12391128925189"
  end

  factory :user_facebook, :class => User do
    name "Test Facebook Guy"
    email "dont123@mail.me"
    password "gaayyyyyyyyyaayaya"
    provider "facebook"
    uid "231241256126136"
  end

  factory :user_google, :class => User do
    name "Test Google Guy"
    email "dont4556@mail.me"
    password "gaayyyyyyyyyaayaya"
    provider "google"
    uid "567567876867"
  end
end