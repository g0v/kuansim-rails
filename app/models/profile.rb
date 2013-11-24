class Profile < ActiveRecord::Base
  attr_accessible :github, :website, :image
  belongs_to :user

  def to_hash
    {
      name: self.user.name,
      email: self.user.email,
      github: self.github,
      website: self.website,
      image: self.image
    }
  end
end
