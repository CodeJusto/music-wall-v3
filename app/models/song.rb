class Song < ActiveRecord::Base
  validates :title, :author, presence: true
  # validates :url, format: { with: /^www\..+\.\w*/ }

  belongs_to :user
  has_many :votes
  has_many :reviews
  
end