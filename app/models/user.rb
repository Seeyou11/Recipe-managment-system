class User < ApplicationRecord
  before_save { self.email = email.downcase if email }
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 25 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?
  has_many :recipes, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :file, dependent: :destroy
  has_many :favorites
  has_many :favorite_recipes, through: :favorites, source: :recipe
  has_secure_password

  def password_required?
    new_record? || password.present?
  end
end
