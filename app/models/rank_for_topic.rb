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

class RankForTopic < ApplicationRecord
  self.primary_key = :id

  def readonly?
    true
  end
end
