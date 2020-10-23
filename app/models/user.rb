class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # フォローしているユーザーを取り出す(user.followedを出来るようにする。)
  # 自分がフォローされる（被フォロー）側の関係性
  has_many :follower_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :follower_relationships, source: :follower

  #フォローされているユーザーを取り出す(user.followersを出来るようにする。)
  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed


  def following?(user_id)
    self.followings.include?(user_id) #controllerのcreateに繋がる。
  end

  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow!(user_id)
    relationships.find_by(followed_id: user_id).destroy #find_byによって1レコードを特定し、destroyメソッドで削除している。
  end

  def User.search(search, user_or_book, how_search)
    if user_or_book == "1"
      if how_search == "1"
        User.where(['name LIKE ?', "%#{search}%"])
      elsif how_search == "2"
        User.where(['name LIKE ?', "%#{search}"])
      elsif how_search == "3"
        User.where(['name LIKE ?', "#{search}%"])
      elsif how_search == "4"
        User.where(['name LIKE ?', "#{search}"])
      else
        User.all
      end
    end
  end

  include JpPrefecture # 都道府県コードから都道府県名に自動で変換する。
  jp_prefecture :prefecture_code

  def prefecture_name #都道府県名を参照出来る様にする。
   JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  attachment :profile_image, destroy: false
  validates :name, presence: true
  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50}
end
