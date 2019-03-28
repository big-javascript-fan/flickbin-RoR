# == Schema Information
#
# Table name: contribution_points
#
#  id         :bigint(8)        not null, primary key
#  tag_id     :integer
#  user_id    :integer
#  amount     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContributionPoint < ApplicationRecord
  belongs_to :user
  belongs_to :tag
end
