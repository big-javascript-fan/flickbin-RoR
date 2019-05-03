# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id           :bigint(8)        not null, primary key
#  user_id      :integer
#  event_object :json
#  category     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Event < ApplicationRecord
  belongs_to :user

  CATEGORIES = %w[
    comment_video
    reply_video_comment
    top_1_contributor
    top_3_contributors
    top_5_contributors
    top_10_contributors
    kicked_out_of_top_contributor
    top_1_video_in_tag
    top_10_videos_in_tag
  ].freeze

  validates_inclusion_of :category, in: CATEGORIES
end
