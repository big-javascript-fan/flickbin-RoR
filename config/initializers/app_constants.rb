module AppConstants
  YOUTUBE_URL_REGEXP = /\A(http)?(s)?(:)\/\/(www\.)?(m\.)?(youtu)(be)?(-nocookie)?(\.be)?(\.com)?.+/
  FACEBOOK_URL_REGEXP = /\Ahttps:\/\/(www\.)?(facebook)(\.com)?.+/
  TWITCH_URL_REGEXP = /\Ahttps:\/\/(www\.)?(twitch)(\.tv)?.+/
  DAILY_MOTION_URL_REGEXP = /\Ahttps:\/\/(www\.)?(dailymotion)(\.com)?.+/
  TAG_TITLE_REGEXP = /\A[a-z\d]*\Z/i
  LIFETIME_IN_DAYS_OF_TAGGED_VIDEO = 10
  MAX_TAG_TITLE_LENGTH = 15
  MAX_CHANNEL_NAME_LENGTH = 30
  MAX_CHANNEL_DESCRIPTION_LENGTH = 160
  MAX_COMMENT_MESSAGE_LENGTH = 1000
  NOT_RATED_USER_EMAILS = %w(bleachtree@gmail.com)
  JS_EXCEPTION_RECIPIENTS = %w(flickbin.developer@gmail.com bleachtree@gmail.com)
end
