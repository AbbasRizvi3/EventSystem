class NotificationMailer < ApplicationMailer
  def notify(user, title, body)
    @user = user
    @title = title
    @body = body
    mail(to: @user.email, subject: title)
  end
end
