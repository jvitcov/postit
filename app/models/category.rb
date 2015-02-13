class Category <ActiveRecord::Base
	include Sluggable
	has_many :post_categories
	has_many :posts, through: :post_categories

	validates :name, presence: true, uniqueness: true

	before_validation :cap_name!
	after_validation :generate_slug!

	sluggable_column :name

	def cap_name!
		self.name = self.name.downcase.capitalize
	end
end