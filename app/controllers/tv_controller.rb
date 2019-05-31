# frozen_string_literal: true

class TvController < ApplicationController
  layout 'application'

  def index
    @tv_props = { channels: [{
      playlist: [
        {
          comments_count: 0,
          cover: { url: 'https://flickbinstaging.s3.amazonaws.com/uploads/video/cover/7576/hqdefault.jpg' },
          created_at: '2019-05-22T05:40:27.003Z',
          duration: 771,
          id: 3845,
          kind_of: 'video',
          length: '00:00:11',
          negative_votes_amount: 0,
          positive_votes_amount: 0,
          rank: 27,
          removed: false,
          slug: 'spinning-cat-2',
          source: 'youtube',
          source_id: 'AKh2W72leuA',
          tag_id: 7,
          twitter_handle: nil,
          title: 'Spinning Cat',
          untagged: false,
          updated_at: '2019-05-22T05:40:27.037Z',
          url: 'https://www.youtube.com/watch?v=AKh2W72leuA&list=PL9FUXHTBubp-_e0wyNu1jfVVJ2QVAi5NW&index=13',
          user_id: 7,
          wasp_outreach: false,
          wasp_post: false
        }, {
          cover: { url: 'https://flickbinstaging.s3.amazonaws.com/uploads/video/cover/7579/sddefault.jpg' },
          created_at: '2019-05-27T10:21:08.548Z',
          duration: 5,
          id: 7579,
          kind_of: 'video',
          length: '00:00:05',
          negative_votes_amount: 0,
          positive_votes_amount: 0,
          rank: 101,
          removed: false,
          slug: 'dubstep-bird-original-5-sec-video',
          source: 'youtube',
          source_id: 'IGQBtbKSVhY',
          tag_id: 1158,
          title: 'Dubstep Bird (Original 5 Sec Video)',
          twitter_handle: nil,
          untagged: false,
          updated_at: '2019-05-27T10:21:08.587Z',
          url: 'https://www.youtube.com/watch?v=IGQBtbKSVhY&list=PLXTVAK9tEuzHo1apGedBCkcPabQNBOtpc&index=15',
          user_id: 7,
          wasp_outreach: false,
          wasp_post: false
        }, {
          cover: { url: 'https://flickbinstaging.s3.amazonaws.com/uploads/video/cover/7577/sddefault.jpg' },
          created_at: '2019-05-22T12:01:41.105Z',
          duration: 241,
          id: 3857,
          kind_of: 'video',
          length: '00:00:19',
          negative_votes_amount: 0,
          positive_votes_amount: 0,
          rank: 101,
          removed: false,
          slug: 'nature-beautiful-short-video-720p-hd',
          source: 'youtube',
          source_id: '668nUCeBHyY',
          tag_id: 1159,
          title: 'Nature Beautiful short video 720p HD',
          twitter_handle: nil,
          untagged: false,
          updated_at: '2019-05-22T06:41:06.191Z',
          url: 'https://www.youtube.com/watch?v=668nUCeBHyY',
          user_id: 7,
          wasp_outreach: false,
          wasp_post: false
        }
      ],
      user: {
        allowed_to_send_notifications: true,
        avatar: {
          thumb_44x44: { url: 'https://flickbinstaging.s3.amazonaws.com/uploads/user/avatar/3/thumb_44x44_3._Komarov.jpg' },
          thumb_128x128: { url: 'https://flickbinstaging.s3.amazonaws.com/uploads/user/avatar/3/thumb_128x128_3._Komarov.jpg' },
          url: 'https://flickbinstaging.s3.amazonaws.com/uploads/user/avatar/3/3._Komarov.jpg'
        },
        channel_description: 'This is a station description',
        channel_name: 'birdy',
        created_at: '2018-10-16T15:46:29.815Z',
        email: 'birskiy.serg@gmail.com',
        fake_avatar_url: '',
        id: 7,
        rank: 0,
        receive_notification_emails: true,
        receive_promotional_emails: true,
        role: 'sidekiq_manager',
        slug: 'serg',
        updated_at: '2018-12-21T16:40:11.502Z'
      }
    }] }
  end
end

# @tv_props = { channels: [] }

# User.limit(10).each do |user|
#     user_videos = Video.includes(:tag)
#                        .active
#                        .where(user_id: user.id)
#                        .order(created_at: :desc)
#                        .limit(10)
#     @tv_props[:channels] << { user: user, playlist: user_videos} unless user_videos.empty?
# end
