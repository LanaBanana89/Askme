class Hashtag < ApplicationRecord
  validates :text, presence: true

  has_and_belongs_to_many :questions, join_table: :hashtags_questions
end
