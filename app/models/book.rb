class Book < ApplicationRecord
is_impressionable or

is_impressionable :counter_cache => true
	belongs_to :user
	has_many :favorites,dependent: :destroy
	# has_many :favorited_users,through: :favorites ,source: :user
	has_many :post_comments,dependent: :destroy


	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}
	validates :evaluation, presence: true
	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

	def last_week # メソッド名は何でも良いです
	  Book.joins(:favorites).where(favorites: { created_at:　0.days.ago.prev_week..0.days.ago.prev_week(:sunday)}).group(:id).order("count(*) desc")
	end
end
