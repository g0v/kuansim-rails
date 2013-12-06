# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Issue.create(
  title: 'Issue 0',
  description: 'Jerry\'s drinking problem.'
)

Issue.create(
  title: 'Serious Sunday Workload',
  description: "Can we have Sunday off not working on anything?"
)

Event.create(
  title: "I basically just want to sleep",
  date_happened: DateTime.now,
  location: 'On my bed',
  description: 'But right now I need to work on this project',
  issue_id: Issue.find_by_title('Serious Sunday Workload').id
)

issue = Issue.where(:title => 'Issue 0')[0].id

Event.create(
  title: 'Group Meeting Binge Drinking',
  date_happened: DateTime.parse('2013-11-10'),
  location: 'Jerry\'s Place',
  description: '5 Beers!',
  issue_id: issue
)

Event.create(
  title: 'Intervention',
  date_happened: DateTime.parse('2013-11-10'),
  location: 'Jerry\'s Place',
  description: 'We love you, Jerry. Please stop hurting yourself!',
  issue_id: issue
)