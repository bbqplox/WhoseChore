class Chore < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  def self.assign_user(user_id, chore_id)
    @chore = where(["id = ?", "#{chore_id}"]).first
    @chore.user = user_id
    @chore.save
  end

  def self.destroy_all_completed(user_id)
    @chores = where(["user_id = ? AND complete = ?", "#{user_id}", "true"])
    @chores.each do |chore|
      chore.destroy
    end
  end

end
