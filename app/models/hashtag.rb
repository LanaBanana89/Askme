class Hashtag < ApplicationRecord
  validates :text, presence: true

  has_and_belongs_to_many :questions, join_table: :hashtags_questions

  # создаём хэштеги из вопроса
  def self.create!(question, hashtags)
    hashtags.each do |hashtag|
      question.hashtags << self.where(text: hashtag).first_or_create
    end
  end

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
