class ChoreRotation < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  belongs_to :chore

  def self.assign_rotation(chore_id, group_id, user_id)
    """
    Create chore rotation assignments if rotaion is specified.
    The specified user will always go first.
    """
    @group = Group.find(group_id)
    @count = 1
    for user in User.active_group_users(@group.id).each do
      if user.id != user_id
        @chore_rotation = ChoreRotation.new(
        chore_id: chore_id, user_id: user.id, group_id: @group.id, order: @count)
        @count += 1
      # this user will be the first to do the chore
      else
        @chore_rotation = ChoreRotation.new(chore_id: chore_id, user_id: user.id, group_id: @group.id, order: 0)
      end
      @chore_rotation.save
    end
  end

  def self.pop_rotation(chore_id)
    """
    Move the person who did the chore last to the end of queue and
    generate a new chore for the next person.
    """
    @chore = Chore.find(chore_id)
    # advance due date for the next chore assignment
    # TODO: grab specified days
    @new_date = Date.parse(@chore.date) + @chore.repeat_days.days
    # copy the chore for the next rotation
    @new_chore = @chore.dup
    @new_chore.date = @new_date
    # save to assign an id
    @new_chore.save

    @chore_rotations = search_by_chore_id(chore_id)
    for chore_rotation in @chore_rotations.each do
      # member who was doing the chore last
      if chore_rotation.order == 0
        chore_rotation.order = @chore_rotaions.size
      end

      # member will be doing the chore next
      if chore_rotation.order == 1
        @new_chore.user_id = chore_rotation.user_id
        @new_chore.save
        Chore.assign(@new_chore.id)
      end
      # update rotationwith the new chore id
      chore_rotation.chore_id = @new_chore.id
      chore_rotation.order -= 1
    end
  end

  def self.remove_rotation(chore_id)
    """
    Remove all chore rotation entries pertaining the specified chore.
    """
    @chore_rotations = search_by_chore_id(chore_id)
    for chore_rotation in @chore_rotations.each
      chore_rotation.destroy
    end
  end

end
