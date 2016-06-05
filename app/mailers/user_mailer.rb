class UserMailer < ApplicationMailer
  default from: 'whosechore@gmail.com'

  def welcome_email(user)
    @user = user
    @url = 'whosechore2.herokuapp.com'
    mail(to: @user.email, subject: 'Welcome to whosechore!')
  end

  def group_invite_email(user, group_name)
    @user = user
    @group_name = group_name
    @url = 'whosechore2.herokuapp.com'
    mail(to: @user.email, subject: 'Whosechore Group Invite')
  end

=begin
  def test_email()
    @url = 'whosechore.herokuapp.com'
    mail(to: 'ttthao@ucsd.edu', subject: 'Welcome to whosechore!')
  end
=end

  def chore_reminder_email(user, chore)
    @user = user
    @chore = chore
    @url = 'whosechore2.herokuapp.com'
    mail(to: @user.email, subject: 'Whosechore Reminder!')
  end

end
