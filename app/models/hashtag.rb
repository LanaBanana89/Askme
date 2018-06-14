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
  def self.clear!(question, hashtags_to_delete)
    hashtags_to_delete.each do |tag|
        hastag = Hashtag.where(text:tag).first
        question.hashtags.delete(hastag)
        hastag.destroy if hastag.questions.empty?
    end
  end
end
