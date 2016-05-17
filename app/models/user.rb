class User < ActiveRecord::Base
	has_one :profile
	before_create :build_profile #creates profile at user registration
	has_secure_password

end
