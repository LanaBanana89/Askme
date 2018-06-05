class Hashtag < ApplicationRecord
  validates :text, presence: true

  has_and_belongs_to_many :questions, join_table: :hashtags_questions

  def self.create!(question)
    hashtags = question.find_hashtag(question.text)

    # если у ответа есть хэштеги, то добавляем их к хэштегам вопроса
    unless question.answer.nil?
      hashtags += question.find_hashtag(question.answer)
    end

    if hashtags.any?
      # передаем массив хэштегов и добавляем к вопросу хэштеги
      hashtags.each do |hashtag|
        question.hashtags << Hashtag.where(text: hashtag).first_or_create
      end
    end
  end

  def self.update!(question)
    hashtags = question.find_hashtag(question.text)
    # обновляем список хэштегов у вопроса
    question.hashtags = Array.new
    Hashtag.create!(question)

    # удаляем хэштеги, если из вопроса удалили хэштег
    Hashtag.clear!
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
