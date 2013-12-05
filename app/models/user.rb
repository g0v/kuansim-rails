class User < ActiveRecord::Base
  require 'open-uri'
  require 'json'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable an
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :provider, :uid
  # attr_accessible :title, :body

  has_many :events
  has_many :issues
  has_one :profile
  before_create :build_default_profile

  has_and_belongs_to_many :followed_issues, class_name: "Issue", join_table: 'users_issues'

  # TODO: CHECK FOR MALFORMED EMAILS
  def self.find_by_provider(user_info, provider)
    raise "Invalid provider" if provider != "google" and provider != "facebook"

    user = User.where(email: user_info["email"]).first ||
      User.where(provider: provider, uid: user_info["id"]).first ||
      User.create!(name: user_info["name"],
        provider: provider,
        uid: user_info["id"],
        email: user_info["email"],
        password: Devise.friendly_token[0, 20]
      )

    user.profile.image = user.image_url(user_info["id"], provider)
    user.profile.save

    user
  end

  def image_url(user_id, provider)
    begin
      if provider == "google"
        google_image_url(user_id)
      else
        uri = URI.parse(facebook_image_url(user_id))
        pic_info = JSON.parse(uri.read)
        pic_info["picture"]["data"]["url"]
      end
    rescue
      ""
    end
  end

  def has_event?(event)
    self.events.include?(event)
  end

  def has_issue?(issue)
    self.issues.include?(issue)
  end

  private

    def build_default_profile
      build_profile
      true
    end

    def google_image_url(id)
      "https://plus.google.com/s2/photos/profile/#{id}?sz=100"
    end

    def facebook_image_url(id)
      "https://graph.facebook.com/#{id}/?fields=picture.type(large)"
    end
end
