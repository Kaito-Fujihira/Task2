class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :followed_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, through: :followed_relationships
  has_many :follower_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships
  def followed?(other_user)
    followed_relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    followed_relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    followed_relationships.find_by(followed_id: other_user.id).destroy
  end

  attachment :profile_image, destroy: false
  validates :name, presence: true
  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates:introduction, length: {maximum: 50}
end
