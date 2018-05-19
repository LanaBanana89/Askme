class Hashtag < ApplicationRecord
  validates :text, presence: true

  has_and_belongs_to_many :questions, join_table: :hashtags_questions

  # метод удаления хэштегов
  def self.clear!
    hashtags = Hashtag.all

    hashtags.each do |hashtag|
      if hashtag.questions.empty?
        hashtag.destroy
      end
    end
  end
end
