class User < ActiveRecord::Base
  require 'open-uri'
  require 'json'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :provider, :uid, :remember_token
  # attr_accessible :title, :body

  has_many :events
  has_one :profile
  before_create :build_default_profile

  # TODO: CHECK FOR MALFORMED EMAILS
  def self.find_by_provider(user_info, provider)
    raise "Invalid provider" if provider != "google" and provider != "facebook"

    user = User.where(provider: provider, uid: user_info["id"]).first
    return user if user

    registered_user = User.where(email: user_info["email"]).first
    return registered_user if registered_user

    user = User.create!(name: user_info["name"],
      provider: provider,
      uid: user_info["id"],
      email: user_info["email"],
      password: Devise.friendly_token[0, 20]
    )
    user.profile.image = user.image_url(user_info["id"], provider)
    user.profile.save

    user
  end

  def image_url(id, provider)
    if provider == "google"
      google_image_url(id)
    else
      uri = URI.parse(facebook_image_url(id))
      pic_info = JSON.parse(uri.read)
      pic_info["picture"]["data"]["url"]
    end
  end

  private

    def google_image_url(id)
      "https://plus.google.com/s2/photos/profile/#{id}"
    end

    def facebook_image_url(id)
      "https://graph.facebook.com/#{id}/?fields=picture.type(large)"
    end

    def build_default_profile
      build_profile
      true
    end
end
