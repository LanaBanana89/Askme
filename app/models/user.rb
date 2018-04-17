require 'openssl'

class User < ApplicationRecord
  # параметры работы модуля шифрования паролей
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new

  has_many :questions

  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true

  # проверка формата email
  validates :email, format: {with:/[\w._%+-]+@[\w.-]+\.[a-zA-Z]{2,4}/, message:'Не верно введён email'}

  # проверка формата юзернейма пользователя (только латинские буквы, цифры, и знак _) и на уникальность
  validates :username, format: {with:/\A\w+\z/, message: 'должен содержать только латинские буквы, цифры, и знак _'},
                       uniqueness: { case_sensitive: false, message: 'такой ник уже существует' }

  # проверка максимальной длинны юзернейма пользователя(не более 40 символов)
  validates :username, :length => { :maximum => 40, message: 'не может быть болше 40 символов' }

  attr_accessor :password

  validates_presence_of :password, on: :create
  validates_confirmation_of :password

  # перед сохранением переводим username в нижний регистр
  before_save { self.username = username.downcase }
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
