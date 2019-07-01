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

require 'rails_helper'

RSpec.describe VideoForHomePage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
