class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  has_many :relationships, foreign_key: followed_id
  has_many :followeds, through: :relationships, source: :follower

  has_many :reverse_of_relationships, class_name: 'relationship', foreign_key: follower_id
  has_many :followers, through: :reverse_of_relationships, source: :followed

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def get_profile_image(width, height)
    unless profile_image.attached?
     file_path = Rails.root.join('app/assets/images/no_image.jpg')
     profile_image.attach(io: File.open(file_path), filename: 'default_image.jpg', content_type: 'image/jpeg')
    end
      profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def is_followed_by?(user)
    reverse_of_relationships.find_by(followed_id: user.id).present?
  end

end
