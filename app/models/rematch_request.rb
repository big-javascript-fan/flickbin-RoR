# == Schema Information
#
# Table name: rematch_requests
#
#  id         :bigint(8)        not null, primary key
#  ip         :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  battle_id  :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_rematch_requests_on_battle_id  (battle_id)
#  index_rematch_requests_on_user_id    (user_id)
#

class RematchRequest < ApplicationRecord
  belongs_to :battle
  belongs_to :user, optional: true 

  validates :ip, presence: true
end
