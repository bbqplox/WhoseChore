class UserMailer < ApplicationMailer
  default from: 'whosechore@gmail.com'

  def welcome_email(user)
    @user = user
    @url = 'whosechore.herokuapp.com'
    mail(to: @user.email, subject: 'Welcome to whosechore!')
    end
end
