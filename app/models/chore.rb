class Chore < ActiveRecord::Base
  #belongs_to :user
  belongs_to :group
  has_many :chore_rotations

  def self.remind(chore_id)
    # TODO: add mail reminder for user
  end

  def self.incomplete_group()
    where(["completed = ?", false])
  end

end
