require 'openssl'

class User < ApplicationRecord
  # параметры работы модуля шифрования паролей
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new

  attr_accessor :password

  has_many :questions

  validates :email, :username, presence: true
  validates :email, uniqueness: true

  # перед валидацией переводим username в нижний регистр
  before_validation do
    self.username = username.downcase;

    # присваиваем цвет по умолчанию, если в поле background_color пусто
    self.background_color = "#005a55" if self.background_color.nil?
  end

  # проверка формата email
  validates :email, format: { with: /[\w._%+-]+@[\w.-]+\.[a-zA-Z]{2,4}/ }

  # проверка формата юзернейма пользователя (только латинские буквы, цифры, и знак _) и на уникальность
  validates :username, format: { with: /\A\w+\z/ },
                       uniqueness: { case_sensitive: false }

  # проверка максимальной длинны юзернейма пользователя(не более 40 символов)
  validates :username, length: { maximum: 40 }
  validates_presence_of :password, on: :create
  validates_confirmation_of :password

  # проверка корректного ввода цвета фона в режиме редактирования профиля
  validates :background_color, format: { with: /\A\#[\da-fA-Z]{6}\z/ }

  before_save :encrypt_password

  def encrypt_password
    if self.password.present?
      # создаём т.н. "соль" - рандомная строка, усложняющая задачу хакерам
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      # создаём хэш пароля - длинная уникальная строка, из которой невозможно установить исходный пароль
      self.password_hash = User.hash_to_string(
          OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST)
      )
    end
  end

  # служебный метод, преобразующий бинарную строку в 16-ричный формат, для удобства хранения
  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email) # сперва находим пользователя по email

    if user.present? && user.password_hash == User.hash_to_string(OpenSSL::PKCS5.pbkdf2_hmac(password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST))
      user
    else
      nil
    end
  end
end
