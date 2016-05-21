class User < ActiveRecord::Base
	has_one :profile
	before_create :build_profile #creates profile at user registration
	has_secure_password
	has_many :memberships
	has_many :groups, :through => :memberships
	has_many :chores
	has_many :group_invites

	def self.search(search)
  	if search
			where(["email LIKE ?", "%#{search}%"])
  	else
    	find_each
  	end
	end

	def self.search_by_email(email)
		where(["email = ?", "#{email}"])
	end

	def self.search_by_id(user_id)
		where(["id = ?", "#{user_id}"])
	end

end
