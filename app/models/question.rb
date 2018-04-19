class Question < ApplicationRecord

  validates :text, :user, presence: true

  # проверка максимальной длины текста вопроса (максимум 255 символов)
  validates :text, length: { maximum: 255 }

  belongs_to :user

  # динамически сгенерируем пару методов для каждого действия,
  # используя возможности руби
  ['validation', 'save', 'create', 'update', 'destroy'].each do |action|
    ['before', 'after'].each do |time|
      define_method("#{time}_#{action}") do
        puts "******> #{time} #{action}"
      end
    end
  end
end
