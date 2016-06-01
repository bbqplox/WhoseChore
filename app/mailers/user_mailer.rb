class UserMailer < ApplicationMailer
  default from: 'whosechore@gmail.com'

  def welcome_email(user)
    @user = user
    @url = 'whosechore.herokuapp.com'
    mail(to: @user.email, subject: 'Welcome to whosechore!')
    end

  def group_invite_email(user, group_name)
    @user = user
    @group_name = group_name
    @url = 'whosechore.herokuapp.com'
    mail(to: @user.email, subject: 'Whosechore Group Invite')
    end
end
