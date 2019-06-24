# frozen_string_literal: true

# == Schema Information
#
# Table name: rank_for_topics
#
#  id          :bigint(8)        primary key
#  rank        :integer
#  title       :string
#  video_count :bigint(8)
#  vote_count  :bigint(8)
#

require 'rails_helper'

RSpec.describe RankForTopic, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
