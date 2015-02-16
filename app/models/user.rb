class User < ActiveRecord::Base
	include Sluggable

	has_many :posts
	has_many :comments
	has_many :votes

	has_secure_password validations: false
	validates :username, presence: true, uniqueness: true
	validates :password, presence: true, on: :create, length: {minimum: 5}
	validates :phone, numericality: {only_interger: true}

	after_validation :generate_slug!

	sluggable_column :username

	def two_factor_auth?
		!self.phone.blank?
	end

	def generate_pin!
		self.update_column(:pin, rand(10 ** 6))
	end

	def remove_pin!
		self.update_column(:pin, nil)
	end

	def send_sms
		# put your own credentials here 
		account_sid = 'ACe14bae529a80cc4a27e07099604f54c0' 
		auth_token = '8877558c3630ebee4ede136cf1db4c9b' 
		 
		# set up a client to talk to the Twilio REST API 
		client = Twilio::REST::Client.new account_sid, auth_token 
		
		msg = "Hi, please enter the pin to continue login: #{self.pin}"
		account = client.account
		message = account.sms.messages.create({:from => '+18312961246', :to => self.phone, :body => msg})
	end

	def admin?
		self.role == 'admin'
	end

	def moderator?
		self.role == 'moderator'
	end
end