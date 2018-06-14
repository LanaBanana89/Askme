class Question < ApplicationRecord
  validates :text, :user, presence: true

  # проверка максимальной длины текста вопроса (максимум 255 символов)
  validates :text, length: { maximum: 255 }

  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true

  has_and_belongs_to_many :hashtags, join_table: :hashtags_questions, dependent: :destroy

  # добавляем к вопросу хэштеги, если они есть
  def add_hashtags
    hashtags_to_add = find_hashtags - hashtags.collect(&:text)
    hashtags_to_delete = hashtags.collect(&:text) - find_hashtags

    Hashtag.create!(self, hashtags_to_add)
    Hashtag.clear!(self, hashtags_to_delete)
  end

  # ищем хэштеги в строке и оставляем только уникальные
  def find_hashtags
    hashtag_regexp = /#[[:word:]-]+/
    (text.to_s + answer.to_s).scan(hashtag_regexp).uniq
  end
end
