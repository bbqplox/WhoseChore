class User < ActiveRecord::Base
	has_one :profile
	has_one :hub
	before_create :build_profile #creates profile at user registration
	before_create :build_hub
	has_secure_password
	has_many :memberships
	has_many :groups, :through => :memberships
	has_many :chores
	has_many :group_invites

	def self.search_index(search)
  	if search
			where(["email LIKE ?", "%#{search}%"])
  	else
    	find_each
  	end
	end

	def self.search(search)
		if search
			where(["email LIKE ?", "%#{search}%"])
		else
			return []
		end
	end

	def self.search_by_email(email)
		where(["email = ?", "#{email}"])
	end

	def self.search_by_id(user_id)
		where(["id = ?", "#{user_id}"])
	end

	def self.active_group_users(group_id)
		@memberships = Membership.active_group_memberships(group_id)
		@users = []
		@memberships.each do |membership|
			@user = User.find(membership.user_id)
			@users << @user
		end
		@users
	end

end
