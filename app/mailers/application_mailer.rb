class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def after_comment(video, comment)
    @video = video
    @user = video.user
    @comment = comment
    mail(to: @user.email, subject: 'Your video has been commented')
  end

  def after_reply_comment(video, comment)
    @video = video
    @user = video.user
    @comment = comment
    mail(to: @user.email, subject: 'Your video has been commented')
  end
end
