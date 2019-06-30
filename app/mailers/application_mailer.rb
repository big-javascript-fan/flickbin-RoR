# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  case Rails.env
  when 'production'
    default from: 'Team Flickbin <noreply@flickbin.tv>'
  when 'staging'
    default from: 'Staging Team Flickbin <noreply@flickbin.tv>'
  else
    default from: 'Development Team Flickbin <noreply@flickbin.tv>'
  end

  layout 'mailer'

  def after_comment(video, comment)
    @video = video
    @user = video.user
    @comment = comment
    return if @user.allowed_to_send_notifications.blank? || @user.receive_notification_emails.blank? || @user.email.include?('teamflickbin.')

    mail(to: @user.email, subject: 'Your post has a new comment!')
  end

  def after_reply_comment(video, comment)
    @video = video
    @comment = comment
    @parent_comment = comment.parent
    @user = @parent_comment.commentator
    return if @user.allowed_to_send_notifications.blank? || @user.receive_notification_emails.blank? || @user.email.include?('teamflickbin.')

    mail(to: @user.email, subject: 'Someone has replied to your comment!')
  end

  def top_1_contributor(tag, contributor)
    @tag = tag
    @contributor = contributor
    return if @contributor.allowed_to_send_notifications.blank? || @contributor.receive_notification_emails.blank? || @contributor.email.include?('teamflickbin.')

    mail(to: @contributor.email, subject: "You're now the top contributor!")
  end

  def top_3_contributors(tag, contributor)
    @tag = tag
    @contributor = contributor
    return if @contributor.allowed_to_send_notifications.blank? || @contributor.receive_notification_emails.blank? || @contributor.email.include?('teamflickbin.')

    mail(to: @contributor.email, subject: "You're now one of the top 3 contributors")
  end

  def top_5_contributors(tag, contributor)
    @tag = tag
    @contributor = contributor
    return if @contributor.allowed_to_send_notifications.blank? || @contributor.receive_notification_emails.blank? || @contributor.email.include?('teamflickbin.')

    mail(to: @contributor.email, subject: "You're now in the top 5")
  end

  def top_10_contributors(tag, contributor)
    @tag = tag
    @contributor = contributor
    return if @contributor.allowed_to_send_notifications.blank? || @contributor.receive_notification_emails.blank? || @contributor.email.include?('teamflickbin.')

    mail(to: @contributor.email, subject: "You're in the running for top contributor")
  end

  def kicked_out_of_top_contributor(tag, contributor)
    @tag = tag
    @contributor = contributor
    return if @contributor.allowed_to_send_notifications.blank? || @contributor.receive_notification_emails.blank? || @contributor.email.include?('teamflickbin.')

    mail(to: @contributor.email, subject: 'You’ve been kicked out as a top contributor')
  end

  def top_1_video_in_tag(video)
    @video = video
    @tag = video.tag
    @user = video.user
    return if @user.allowed_to_send_notifications.blank? || @user.receive_notification_emails.blank? || @user.email.include?('teamflickbin.')

    mail(to: @user.email, subject: "Your post is #1 in #{@tag.title}!")
  end

  def top_10_videos_in_tag(video)
    @video = video
    @tag = video.tag
    @user = video.user
    return if @user.allowed_to_send_notifications.blank? || @user.receive_notification_emails.blank? || @user.email.include?('teamflickbin.')

    mail(to: @user.email, subject: "Your post is now top ten in the #{@tag.title} tag.")
  end

  def three_days_after_confirmation(user)
    @user = user
    return if user.confirmed_at.blank? || @user.allowed_to_send_notifications.blank? || @user.receive_notification_emails.blank? || @user.email.include?('teamflickbin.')

    mail(to: @user.email, subject: 'Try posting a video!')
  end

  def four_days_after_confirmation(user)
    @user = user
    return if user.confirmed_at.blank? || @user.allowed_to_send_notifications.blank? || @user.receive_notification_emails.blank? || @user.email.include?('teamflickbin.')

    mail(to: @user.email, subject: 'Creating a Tag')
  end

  def five_days_after_confirmation(user)
    @user = user
    return if user.confirmed_at.blank? || @user.allowed_to_send_notifications.blank? || @user.receive_notification_emails.blank? || @user.email.include?('teamflickbin.')

    mail(to: @user.email, subject: 'Top Contributor, Your Pathway to Stardom on flickbin')
  end

  def weekly_mailing(user, tags_with_vidoes)
    @user = user
    @tags_with_vidoes = tags_with_vidoes
    return if @user.allowed_to_send_notifications.blank? || @user.receive_notification_emails.blank? || @user.email.include?('teamflickbin.')

    mail(to: @user.email, subject: 'Trending Now on Flickbin.')
  end

  def notify_exception(recipient, exception, source)
    @exception = exception
    @source = source
    mail(to: recipient, subject: 'Flickbin JS Exception')
  end
end
