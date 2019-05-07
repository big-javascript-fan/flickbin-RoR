# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id             :bigint(8)        not null, primary key
#  ancestry       :string
#  ancestry_depth :integer          default(0)
#  message        :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  commentator_id :integer
#  parent_id      :integer
#  video_id       :integer
#
# Indexes
#
#  index_comments_on_ancestry                     (ancestry)
#  index_comments_on_commentator_id               (commentator_id)
#  index_comments_on_parent_id                    (parent_id)
#  index_comments_on_video_id_and_commentator_id  (video_id,commentator_id)
#

class Comment < ApplicationRecord
  has_ancestry cache_depth: true

  belongs_to :video, counter_cache: true
  belongs_to :commentator, class_name: 'User'
  belongs_to :parent, class_name: 'Comment', optional: true, inverse_of: :parent
  has_many :subcomments, class_name: 'Comment', foreign_key: :parent_id, inverse_of: :subcomments

  before_validation :check_ancestry_depth

  # validate :reply_comment
  validates_presence_of :message
  validates_length_of   :message, maximum: AppConstants::MAX_COMMENT_MESSAGE_LENGTH,
                                  allow_blank: true

  def reply_comment
    return if root? || parent.commentator_id != commentator_id

    errors.add(:reply_comment, 'forbidden to comment your own comment')
  end

  def check_ancestry_depth
    errors.add(:ancestry_depth, 'level cannot be more than 1') if depth > 1
  end
end
