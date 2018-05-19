class Question < ApplicationRecord
  validates :text, :user, presence: true

  # проверка максимальной длины текста вопроса (максимум 255 символов)
  validates :text, length: { maximum: 255 }

  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true

  has_and_belongs_to_many :hashtags, join_table: :hashtags_questions

  def create_hashtags!
    hashtags = find_hashtag(self.text)

    # если у ответа есть хэштеги, то добавляем их к хэштегам вопроса
    unless self.answer.nil?
      hashtags += find_hashtag(self.answer)
    end

    if hashtags.any?
      # передаем массив хэштегов и добавляем к вопросу хэштеги
      hashtags.each do |hashtag|
        self.hashtags << Hashtag.where(text: hashtag).first_or_create
      end
    end
  end

  def update_hashtags!
    # ищем хэштеги
    hashtags = find_hashtag(self.text)

    # обновляем список хэштегов у вопроса
    self.hashtags = Array.new
    self.create_hashtags!

    # удаляем хэштеги, если из вопроса удалили хэштег
    Hashtag.clear!
  end

  # ищем хэштеги в строке
  def find_hashtag(string)
    hashtag_regexp = /#[[:word:]-]+/
    hashtags = string.scan(hashtag_regexp)
  end
end
