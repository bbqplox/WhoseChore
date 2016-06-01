class ChoreRotation < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  belongs_to :chore

  def self.search_by_group_id(group_id)
    where(["group_id = ?", "#{group_id}"])
  end

  def self.search_by_chore_id(chore_id)
    where(["chore_id = ?", "#{chore_id}"])
  end

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
    @new_chore.complete = false
    # save to assign an id
    @new_chore.save

    @chore_rotations = @chore.chore_rotations
    for chore_rotation in @chore_rotations.each do
      # member who was doing the chore last
      if chore_rotation.order == 0
        chore_rotation.order = @chore_rotations.size
      end

      # update rotationwith the new chore id
      chore_rotation.chore_id = @new_chore.id
      chore_rotation.order -= 1
      chore_rotation.save

      # member will be doing the chore next
      if chore_rotation.order == 0
        @new_chore.user_id = chore_rotation.user_id
        @new_chore.save
        #Chore.remind(@new_chore.id)
      end

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

  def self.remove_rotation_member(user_id, group_id)
    """
    Removes the specified user from all chore rotations belonging to the group.
    """
    # retrieve all group's chores with repeats
    @chores = Chore.where(["group_id = ? and repeat_days > 0", "#{group_id}"])
    for chore in @chores do
      @chore_rotations = ChoreRotation.search_by_chore_id(chore.id)
      # iterate through rotation of coresponding chore
      @count = 0
      for chore_rotation in @chore_rotations
        # specified user found, delete the entry
        if chore_rotation.user_id == user_id
          chore_rotation.destroy
          # reassign ordering for other members
        else
          chore_rotation.order = @count
          chore_rotation.save
          # change the person responsible for the chore
          if @count == 0
            chore.user_id = chore_rotation.user_id
            chore.save
          end
          @count += 1
        end
      end
    end
  end

  def self.add_rotation_member(user_id, group_id)
    """
    Adds the specified user to all chore rotations belonging to the group.
    """
    # retrieve all group's chores with repeats
    @chores = Chore.where(["group_id = ? and repeat_days > 0", "#{group_id}"])
    for chore in @chores do
      # get rotation member count
      @count = ChoreRotation.search_by_chore_id(chore.id).count

      # assign user as the last order in the rotation
      @chore_rotation = ChoreRotation.new(
      chore_id: chore.id, user_id: user_id, group_id: group_id, order: @count)
      @chore_rotation.save
    end
  end

  def self.member_order(chore_id)
    """
    Returns the list of all member in the chore rotation in their order.
    """
    @chore = Chore.find(chore_id)
    @users = []

    # return empty list if not a repeated chore
    if @chore.repeat_days > 0
      @chore_rotations = ChoreRotation.search_by_chore_id(chore_id)
      @chore_rotations.sort {|a,b| a.order <=> b.order }.each do |chore_rotation|
        @user = User.find(chore_rotation.user_id)
        @users << @user
      end
    end
    @users
  end

end
