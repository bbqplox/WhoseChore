class Chore < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  def self.assign_user(user_id, chore_id)
    @chore = where(["id = ?", "#{chore_id}"]).first
    @chore.user = user_id
    @chore.save
  end
  
end
