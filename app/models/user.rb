class User < ActiveRecord::Base
  validates :password, presence: true
  validate :email_check

  has_many :songs
  has_many :votes
  has_many :reviews


private
  def email_check
    if User.where(email: self.email).length > 0
      errors.add(:email, 'already exists.')
    else
      true
    end
  end

end