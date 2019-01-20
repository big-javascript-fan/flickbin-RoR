class ApplicationMailer < ActionMailer::Base
  default from: 'flickbin.team@gmail.com'
  layout 'mailer'

  def after_comment(video, comment)
    @video = video
    @user = video.user
    @comment = comment
    return if @user.allowed_to_send_notifications.blank? || @user.receive_notification_emails.blank?

    mail(to: @user.email, subject: 'Your post has a new comment!')
  end

  def after_reply_comment(video, comment)
    @video = video
    @comment = comment
    @parent_comment = comment.parent
    @user = @parent_comment.commentator
    return if @user.allowed_to_send_notifications.blank? || @user.receive_notification_emails.blank?

    mail(to: @user.email, subject: 'Someone has replied to your comment!')
  end

  def top_1_contributor(tag, contributor)
    @tag = tag
    @contributor = contributor
    return if @contributor.allowed_to_send_notifications.blank? || @contributor.receive_notification_emails.blank?

    mail(to: @contributor.email, subject: "You're now the top contributor!")
  end

  def top_3_contributors(tag, contributor)
    @tag = tag
    @contributor = contributor
    return if @contributor.allowed_to_send_notifications.blank? || @contributor.receive_notification_emails.blank?

    mail(to: @contributor.email, subject: "You're now one of the top 3 contributors")
  end

  def top_5_contributors(tag, contributor)
    @tag = tag
    @contributor = contributor
    return if @contributor.allowed_to_send_notifications.blank? || @contributor.receive_notification_emails.blank?

    mail(to: @contributor.email, subject: "You're now in the top 5")
  end

  def top_10_contributors(tag, contributor)
    @tag = tag
    @contributor = contributor
    return if @contributor.allowed_to_send_notifications.blank? || @contributor.receive_notification_emails.blank?

    mail(to: @contributor.email, subject: "You're in the running for top contributor")
  end

  def top_1_video_in_tag(video)
    @video = video
    @tag = video.tag
    @user = video.user
    return if @user.allowed_to_send_notifications.blank? || @user.receive_notification_emails.blank?

    mail(to: @user.email, subject: "Your post is #1 in #{@tag.title}!")
  end

  def top_10_videos_in_tag(video)
    @video = video
    @tag = video.tag
    @user = video.user
    return if @user.allowed_to_send_notifications.blank? || @user.receive_notification_emails.blank?

    mail(to: @user.email, subject: "Your post is now top ten in the #{@tag.title} tag.")
  end

  def three_days_after_confirmation(user)
    @user = user
    return if @user.allowed_to_send_notifications.blank? || @user.receive_notification_emails.blank?

    mail(to: @user.email, subject: "Hello #{@user.channel_name}!")
  end

  def four_days_after_confirmation(user)
    @user = user
    return if @user.allowed_to_send_notifications.blank? || @user.receive_notification_emails.blank?

    mail(to: @user.email, subject: "Hello #{@user.channel_name}!")
  end

  def five_days_after_confirmation(user)
    @user = user
    return if @user.allowed_to_send_notifications.blank? || @user.receive_notification_emails.blank?

    mail(to: @user.email, subject: "Hello #{@user.channel_name}!")
  end

  def once_a_week_on_fridays(user, top_5_tags)
    @user = user
    @top_5_tags = top_5_tags
    return if @user.allowed_to_send_notifications.blank? || @user.receive_notification_emails.blank?

    mail(to: @user.email, subject: "There have been some whoppers this week.")
  end
end
