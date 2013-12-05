FactoryGirl.define do

  factory :issue do
    title 'Bart Strike'
    description "Renegotiating employee contract."
  end

  factory :drinking_issue, :class => Issue do
    title 'Binge Drinking in College'
    description "Increased drinking on college campus"
  end

  factory :bart_strike_issue, :class => Issue do
    title 'Bart Strike'
    description "Workers want increased benefits"
  end

  factory :malaysia_strike_issue, :class => Issue do
    title 'Strike in Malaysia'
    description "The rice farmers are revolting!"
  end
end