module AppConstants
  YOUTUBE_URL_REGEXP = /\Ahttps:\/\/(www\.)?(youtube|m.youtube|youtu.be)(\.com)?.+/
  TAG_TITLE_REGEXP = /\A[a-z\d]*\Z/i
  LIFETIME_IN_DAYS_OF_TAGGED_VIDEO = 10
  MAX_TAG_TITLE_LENGTH = 15
  MAX_CHANNEL_DESCRIPTION_LENGTH = 160
  MAX_COMMENT_MESSAGE_LENGTH = 1000
end
