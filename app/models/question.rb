class Question < ApplicationRecord
  validates :text, :user, presence: true

  # проверка максимальной длины текста вопроса (максимум 255 символов)
  validates :text, length: { maximum: 255 }

  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true

  has_and_belongs_to_many :hashtags, join_table: :hashtags_questions, dependent: :destroy

  # добавляем к вопросу хэштеги, если они есть
  def add_hashtags
    string = self.text + " " + self.answer.to_s
    hashtags = find_hashtags(string)
    self.hashtags = Array.new
    if hashtags.any?
      Hashtag.create!(self, hashtags)
    end
    Hashtag.clear!
  end

  # ищем хэштеги в строке и оставляем только уникальные
  def find_hashtags(string)
    hashtag_regexp = /#[[:word:]-]+/
    hashtags = string.scan(hashtag_regexp).uniq
  end
end
