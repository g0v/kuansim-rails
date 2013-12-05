FactoryGirl.define do

  factory :event do
    title 'Bart Strike'
    location 'San Francisco, CA'
    description "This is a horrible event!"
    date_happened DateTime.parse(Time.at(1234567.0 / 1000.0).to_s)
  end
end