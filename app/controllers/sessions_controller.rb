class SessionsController < ApplicationController
	def new

	end

	def create
		user = User.where(username: params[:username]).first
		if user && user.authenticate(params[:password])
			if user.two_factor_auth?
				session[:two_factor] = true
				user.generate_pin!
				user.send_sms
				redirect_to pin_path
			else
				login_success(user)
			end
		else
			flash[:error] = 'There is something wrong with your username or password.'
			redirect_to login_path
		end
	end

	def destroy
		session[:user_id] = nil
		flash[:notice] = "You've logged out."
		redirect_to root_path
	end

	def pin
		access_denied if session[:two_factor].nil?
		if request.post?
			user = User.find_by pin: params[:pin]
			if user
				session[:two_factor] = nil
				user.remove_pin!
				login_success(user)
			else
				flash[:error] = "Sorry, something is wrong with your pin number."
				redirect_to pin_path
			end
		end
	end

	private

	def login_success(user)
		session[:user_id] = user.id
		flash[:notice] = "Welcome, you're logged in."
		redirect_to root_path
	end
end