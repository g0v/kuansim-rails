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

issue_arab_spring = Issue.create(
  title: "Arab Spring",
  description:  "A revolutionary wave of demonstrations and protests (both non-violent and violent), " +
                "riots, and civil wars in the Arab world."
)

issue_bart_strike = Issue.create(
  title: "Bart Strike 2013",
  description: "The Bay Area Rapid Transit strike of 2013."
)

issue_syrian_civil_war = Issue.create(
  title: "Syrian Civil War",
  description: "An ongoing armed conflict in Syria between forces loyal to the Ba'ath government and those seeking to oust it."
)

######END ISSUES######

######EVENTS######

syria_1 = Event.create(
  title: "The Syrian civil war is breeding a new generation of terrorist",
  description:  "Hundreds of radicalised young Muslims are reported to have made their way to Syria from " +
                "other Western nations, such as the US, Canada and France, while intelligence officials " +
                "have been surprised at the large number of Australian nationals - estimated at around 200 " +
                "- who have travelled halfway round the world to fight.",
  date_happened: DateTime.parse("2011-03-15"),
  location: "Syria",
  url: "http://www.telegraph.co.uk/news/worldnews/middleeast/syria/10491523/The-Syrian-civil-war-is-breeding-a-new-generation-of-terrorist.html"
)

syria_2 = Event.create(
  title: "Syrian army secures Damascus-Homs motorway",
  description: "Syrian government forces are reported to have taken control of the motorway linking Damascus with the city of Homs.",
  date_happened: DateTime.parse("2013-12-09"),
  location: "Damascus, Syria",
  url: "http://www.bbc.co.uk/news/world-middle-east-25299816"
)

egypt_1 = Event.create(
  title: "Egyptian youth activists need protest plan",
  description: "Egyptian youth activists need protest plan.",
  date_happened: DateTime.parse("2013-12-09"),
  location: "Cairo, Egypt",
  url: "http://www.al-monitor.com/pulse/originals/2013/12/egypt-youth-activists-need-plan.html#"
)

bart_1 = Event.create(
  title: "Tentative End to BART Strike",
  description: "Union officials are announcing a tentative end to the four-day BART transit strike.",
  date_happened: DateTime.parse("2013-10-20"),
  location: "San Francisco",
  url: "http://www.usatoday.com/story/news/nation/2013/10/20/bart-strike-san-francisco-monday/3096849/"
)

bart_2 = Event.create(
  title: "Proposed Law Would Ban Strikes By Public Transit Workers in California",
  description:  "Employees of public transit systems in California may soon be barred from going on strike " +
                "under new legislation proposed Monday.",
  date_happened: DateTime.parse("2013-12-09"),
  location: "Bay Area",
  url: "http://www.nbcbayarea.com/news/california/Proposed-Law-Would-Ban-Strikes-By-Public-Transit-Workers-in-California-235161941.html"
)

bart_3 = Event.create(
  title: "Strike three? BART workers considering next steps as directors reject paid-leave provision",
  description:  "BART's Board of Directors voted to approve a labor contract between BART and its workers but " +
                "removed a controversial section of the agreement.",
  date_happened: DateTime.parse("2013-11-21"),
  location: "Bay Area",
  url: "http://www.sfexaminer.com/sanfrancisco/unions-cry-foul-as-bart-board-removes-paid-medical-leave-from-contract/Content?oid=2632177"
)

######END EVENTS######

######RELATIONS######

#user-issue relations#
user3.issues << issue_arab_spring
user1.issues << issue_bart_strike

#follow-issue relations#
user1.followed_issues << issue_arab_spring
user1.followed_issues << issue_bart_strike
user2.followed_issues << issue_arab_spring
user3.followed_issues << issue_bart_strike

user4.followed_issues << issue_arab_spring
user4.followed_issues << issue_bart_strike

#user-event relations#
user4.events << syria_1
user4.events << syria_2
user4.events << bart_3

user3.events << bart_1

#event-issue relations#
syria_1.issues << issue_arab_spring
syria_2.issues << issue_arab_spring
egypt_1.issues << issue_arab_spring

syria_1.issues << issue_syrian_civil_war
syria_2.issues << issue_syrian_civil_war

bart_1.issues << issue_bart_strike
bart_2.issues << issue_bart_strike
bart_3.issues << issue_bart_strike


######END RELATIONS######