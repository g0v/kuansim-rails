FactoryGirl.define do

  factory :event do
    title 'BART Strike Ends'
    description  'Governor Jerry Brown announces end to BART strike'
    date_happened DateTime.parse(Time.at(1234567.0 / 1000.0).to_s)
  end

end