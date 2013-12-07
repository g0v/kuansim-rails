# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

issue1 = Issue.create(
  title: 'Issue 0',
  description: 'Jerry\'s drinking problem.'
)

issue2 = Issue.create(
  title: 'Serious Sunday Workload',
  description: "Can we have Sunday off not working on anything?"
)

issue2.events << Event.create(
  title: "I basically just want to sleep",
  date_happened: DateTime.now,
  location: 'On my bed',
  description: 'But right now I need to work on this project',
  url: 'http://www.bbc.com'
)

issue1.events << Event.create(
  title: 'Group Meeting Binge Drinking',
  date_happened: DateTime.parse('2013-11-10'),
  location: 'Jerry\'s Place',
  description: '5 Beers!',
  url: 'http://www.ddc.com'
)

issue1.events << Event.create(
  title: 'Intervention',
  date_happened: DateTime.parse('2013-11-10'),
  location: 'Jerry\'s Place',
  description: 'We love you, Jerry. Please stop hurting yourself!',
  url: 'http://www.eec.com'
)