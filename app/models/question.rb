class Question < ApplicationRecord
  validates :text, :user, presence: true

  # проверка максимальной длины текста вопроса (максимум 255 символов)
  validates :text, length: { maximum: 255 }

  belongs_to :user
end
