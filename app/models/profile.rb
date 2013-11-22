class Profile < ActiveRecord::Base
  attr_accessible :github, :website, :image
  belongs_to :user

  def to_hash
    {
      github: self.github,
      website: self.website,
      image: self.image
    }
  end
end
