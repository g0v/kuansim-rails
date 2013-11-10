class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :provider, :uid
  # attr_accessible :title, :body

  has_many :events

  # TODO: CHECK FOR MALFORMED EMAILS
  def self.find_by_provider(user_info, provider)
    raise "Invalid provider" if provider != "google" and provider != "facebook"

    user = User.where(provider: provider, uid: user_info[:id]).first
    return user if user

    registered_user = User.where(email: user_info[:email]).first
    return registered_user if registered_user


    User.create!(name: user_info[:name],
      provider: provider,
      uid: user_info[:id],
      email: user_info[:email],
      password: Devise.friendly_token[0, 20]
    )

  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(name:auth.extra.raw_info.name,
          provider:auth.provider,
          uid:auth.uid,
          email:auth.info.email,
          password:Devise.friendly_token[0,20],
          )
      end
    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    if user
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(name: data["name"],
          provider:access_token.provider,
          email: data["email"],
          uid: access_token.uid ,
          password: Devise.friendly_token[0,20],
          )
      end
    end
  end
  
end
