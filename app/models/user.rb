class User < ActiveRecord::Base
	has_secure_password
	has_many :memberships
	has_many :groups, :through => :memberships

	def self.search(search)
  	if search
			where(["email LIKE ?", "%#{search}%"])
  	else
    	find_each
  	end
	end

end
