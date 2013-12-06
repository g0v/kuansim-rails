FactoryGirl.define do

  factory :user do
    id 1
    name "Test Guy"
    email "dont@mail.me"
    password "gaayyyyyyyyyaayaya"
    provider "google"
    uid "12391128925189"
  end

  factory :power_user, :class => User do
    name "Test Power Guy"
    email "dont123456@mail.me"
    password "itsasecret"
    provider "google"
    uid "22222222222222"
  end

  factory :user_facebook, :class => User do
    id 2
    name "Test Facebook Guy"
    email "dont123@mail.me"
    password "gaayyyyyyyyyaayaya"
    provider "facebook"
    uid "231241256126136"
  end

  factory :user_google, :class => User do
    id 3
    name "Test Google Guy"
    email "dont4556@mail.me"
    password "gaayyyyyyyyyaayaya"
    provider "google"
    uid "567567876867"
  end
end