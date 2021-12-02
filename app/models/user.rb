class User < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites,dependent: :destroy
  has_many :post_comments,dependent: :destroy
  
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  attachment :profile_image, destroy: false

  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50}


  has_many :relationships, foreign_key: "follow_id", dependent: :destroy
  has_many :follows, through: :relationships, source: :followed

  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'followed_id'
  has_many :followers, through: :reverse_of_relationships, source: :follow

  def follow(other_user)
    unless self == other_user
    self.relationships.find_or_create_by(followed_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(followed_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.follows.include?(other_user)

  end


end