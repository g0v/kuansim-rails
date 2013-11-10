# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Issue.create(
	title: 'Issue 0', 
	datetime: '11/10/13', 
	description: 'Jerry\'s drinking problem.'
)

issue = Issue.where(:title => 'Issue 0')[0].id

Event.create(
	title: 'Group Meeting Binge Drinking',
	datetime: '11/10/13',
	location: 'Jerry\'s Place',
	description: '5 Beers!',
	issue_id: issue
)

Event.create(
	title: 'Intervention',
	datetime: '11/11/13',
	location: 'Jerry\'s Place',
	description: 'We love you, Jerry. Please stop hurting yourself!',
	issue_id: issue
)

Tag.create(
	name: '#InsufficientAlcohol',
	event_id: Event.where(:title => 'Group Meeting Binge Drinking')[0].id
)

Tag.create(
	name: '#LeaveJerryAlone',
	event_id: Event.where(:title => 'Intervention')[0].id
)
	

