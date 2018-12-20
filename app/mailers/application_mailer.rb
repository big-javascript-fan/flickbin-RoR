class ApplicationMailer < ActionMailer::Base
  default from: 'flickbin.team@gmail.com'
  layout 'mailer'

  def after_comment(video, comment)
    @video = video
    @user = video.user
    @comment = comment
    mail(to: @user.email, subject: 'Your video has been commented')
  end

  def after_reply_comment(video, comment)
    @video = video
    @comment = comment
    @parent_comment = comment.parent
    @user = @parent_comment.commentator
    mail(to: @user.email, subject: 'Someone reply to your comment')
  end

  def top_1_contributor(tag, contributor)
    @tag = tag
    @contributor = contributor
    mail(to: @contributor.email, subject: "You're now the top contributor")
  end

  def top_3_contributors(tag, contributor)
    @tag = tag
    @contributor = contributor
    mail(to: @contributor.email, subject: "You're now one of the top 3 contributors")
  end

  def top_5_contributors(tag, contributor)
    @tag = tag
    @contributor = contributor
    mail(to: @contributor.email, subject: "You're now one of the top 5 contributors")
  end

  def top_10_contributors(tag, contributor)
    @tag = tag
    @contributor = contributor
    mail(to: @contributor.email, subject: "You're now one of the top 10 contributors")
  end

  def top_1_video_in_tag(video)
    @video = video
    @tag = video.tag
    @user = video.user
    mail(to: @user.email, subject: "Your Video is #1 on #{@tag.title}.")
  end

  def top_10_videos_in_tag(video)
    @video = video
    @tag = video.tag
    @user = video.user
    mail(to: @user.email, subject: "Your Video is now in the top ten in the #{@tag.title} tag.")
  end

  def three_days_after_confirmation(user)
    @user = user
    mail(to: @user.email, subject: "Hello #{@user.channel_name}.")
  end

  def four_days_after_confirmation(user)
    @user = user
    mail(to: @user.email, subject: "Hello #{@user.channel_name}.")
  end

  def five_days_after_confirmation(user)
    @user = user
    mail(to: @user.email, subject: "Hello #{@user.channel_name}.")
  end

  def once_a_week_on_fridays(user, top_5_tags)
    @user = user
    @top_5_tags = top_5_tags
    mail(to: @user.email, subject: "There have been some whoppers this week.")
  end
end
