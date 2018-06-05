class Question < ApplicationRecord
  validates :text, :user, presence: true

  # проверка максимальной длины текста вопроса (максимум 255 символов)
  validates :text, length: { maximum: 255 }

  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true

  has_and_belongs_to_many :hashtags, join_table: :hashtags_questions

  # ищем хэштеги в строке
  def find_hashtag(string)
    hashtag_regexp = /#[[:word:]-]+/
    hashtags = string.scan(hashtag_regexp)
  end
end
