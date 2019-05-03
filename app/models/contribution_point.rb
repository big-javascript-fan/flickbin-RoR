# frozen_string_literal: true

# == Schema Information
#
# Table name: contribution_points
#
#  id         :bigint(8)        not null, primary key
#  amount     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag_id     :integer
#  user_id    :integer
#
# Indexes
#
#  index_contribution_points_on_amount              (amount)
#  index_contribution_points_on_tag_id              (tag_id)
#  index_contribution_points_on_tag_id_and_amount   (tag_id,amount)
#  index_contribution_points_on_user_id_and_tag_id  (user_id,tag_id)
#

class ContributionPoint < ApplicationRecord
  belongs_to :user
  belongs_to :tag
end
