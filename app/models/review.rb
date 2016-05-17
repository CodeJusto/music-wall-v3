class Review < ActiveRecord::Base
  validate :review_check
  validates :score, numericality: { only_integer: true, less_than_or_equal_to: 5, greater_than_or_equal_to: 1 }

  belongs_to :user
  belongs_to :song

  private
  def review_check
    if Review.where(user_id: self.user_id, song_id: self.song_id).length > 0
      errors.add(:user_id, 'cannot review more than once on the same song')
    else
      true
    end
  end
end