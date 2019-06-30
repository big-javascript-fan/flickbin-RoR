# frozen_string_literal: true

# == Schema Information
#
# Table name: video_for_home_pages
#
#  id                :bigint(8)        primary key
#  cover             :string
#  slug              :string
#  source            :string
#  tag_slug          :string
#  tag_title         :string
#  title             :string
#  user_avatar       :string
#  user_channel_name :string
#  user_slug         :string
#  source_id         :string
#  user_id           :bigint(8)
#

class VideoForHomePage < ApplicationRecord
  self.primary_key = :id

  extend FriendlyId
  friendly_id :title, use: %i[sequentially_slugged finders]

  mount_uploader :cover, VideoCoverUploader
  mount_uploader :user_avatar, UserAvatarUploader

  def readonly?
    true
  end
end
