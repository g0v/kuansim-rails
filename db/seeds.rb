# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

######USERS######

user1 = User.create(
  email: "mscott2000@gmail.com",
  name: "Michael Scott"
)

user2 = User.create(
  email: "ajenson999@hotmail.com",
  name: "Adam Jenson"
)

user3 = User.create(
  email: "nbrody43@gmail.com",
  name: "Nicholas Brody"
)

user4 = User.create!(
        name: "Andrew Chen",
        provider: "Facebook",
        uid: "1",
        email: "aychen92@gmail.com",
        password: Devise.friendly_token[0, 20]
)

######END USERS######

######ISSUES######

issue1 = Issue.create(
  title: "Arab Spring",
  description:  "A revolutionary wave of demonstrations and protests (both non-violent and violent), " +
                "riots, and civil wars in the Arab world."
)

issue2 = Issue.create(
  title: "Bart Strike 2013",
  description: "The Bay Area Rapid Transit strike of 2013."
)

issue3 = Issue.create(
  title: "Syrian Civil War",
  description: "An ongoing armed conflict in Syria between forces loyal to the Ba'ath government and those seeking to oust it."
)

######END ISSUES######

######EVENTS######

event1 = Event.create(
  title: "The Syrian civil war is breeding a new generation of terrorist",
  description:  "Hundreds of radicalised young Muslims are reported to have made their way to Syria from " +
                "other Western nations, such as the US, Canada and France, while intelligence officials " +
                "have been surprised at the large number of Australian nationals - estimated at around 200 " +
                "- who have travelled halfway round the world to fight.",
  date_happened: DateTime.parse("2011-03-15"),
  location: "Syria",
  url: "http://www.telegraph.co.uk/news/worldnews/middleeast/syria/10491523/The-Syrian-civil-war-is-breeding-a-new-generation-of-terrorist.html"
)

event2 = Event.create(
  title: "Tentative End to BART Strike",
  description: "Union officials are announcing a tentative end to the four-day BART transit strike.",
  date_happened: DateTime.parse("2013-10-20"),
  location: "San Francisco",
  url: "http://www.usatoday.com/story/news/nation/2013/10/20/bart-strike-san-francisco-monday/3096849/"
)

######END EVENTS######

######RELATIONS######

#user-issue relations#
user3.issues << issue1
user1.issues << issue2

#follow-issue relations#
user1.followed_issues << issue1
user1.followed_issues << issue2
user2.followed_issues << issue1
user3.followed_issues << issue2

#user-event relations#
user4.events << event1
user3.events << event2

#event-issue relations#
event1.issues << issue1
event1.issues << issue3
event2.issues << issue2

# issue1.events << event1
# issue2.events << event2
# issue3.events << event1

######END RELATIONS######