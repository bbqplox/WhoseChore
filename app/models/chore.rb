class Chore < ActiveRecord::Base
  #belongs_to :user
  belongs_to :group
  has_many :chore_rotations
  validates :Name, :Description, :Date, :score, :presence => true

  def self.remind(chore_id)
    # TODO: add mail reminder for user
  end

  def self.incomplete()
    where(["completed = false"])
  end

  def self.destroy_all_completed(user_id)
    @chores = where(["complete = true AND user_id = ?", "#{user_id}"])
    for chore in @chores.each
      ChoreRotation.remove_rotation(chore.id)
      chore.destroy
    end
  end

  def self.search_by_group_id(group_id)
		where(["group_id = ?", "#{group_id}"])
	end

end
