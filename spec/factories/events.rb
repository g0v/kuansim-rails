FactoryGirl.define do

  factory :event do
    title 'BART Strike Ends'
    description  'Governor Jerry Brown announces end to BART strike'
    date_happened DateTime.parse(Time.at(1234567.0 / 1000.0).to_s)
    url 'http://www.bbc.com'
  end

  factory :bart_event, :class => Event do
    title 'Bart Strike'
    location 'San Francisco, CA'
    description "This is a horrible event!"
    date_happened 1234567
    url 'http://www.bbc.com'
  end

  factory :freshmen_drink, :class => Event do
    title 'Record amount of freshmen hospital'
    location 'Berkeley, CA'
    description 'Freshmen are dumb'
    date_happened 984303
    url 'http://www.bbc.com'
  end

  factory :malaysia_event, :class => Event do
    title 'Rice farmers strike'
    location 'Malaysia'
    description 'Rice farmers want more things'
    date_happened 92840
    url 'http://www.bbc.com'
  end
end