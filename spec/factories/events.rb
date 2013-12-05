FactoryGirl.define do

  factory :event do
    title 'Bart Strike'
    location 'San Francisco, CA'
    description "This is a horrible event!"
    date_happened DateTime.parse(Time.at(1234567.0 / 1000.0).to_s)
  end

  factory :bart_event, :class => Event do
    title 'Bart Strike'
    location 'San Francisco, CA'
    description "This is a horrible event!"
    date_happened 1234567
  end

  factory :freshmen_drink, :class => Event do
    title 'Record amount of freshmen hospital'
    location 'Berkeley, CA'
    description 'Freshmen are dumb'
    date_happened 984303
  end

  factory :malaysia_event, :class => Event do
    title 'Rice farmers strike'
    location 'Malaysia'
    description 'Rice farmers want more things'
    date_happened 92840
  end

end