class Battle < ApplicationRecord
  STATUSES = %w(active completed)

  belongs_to :tag
  belongs_to :first_member, class_name: 'User', foreign_key: :first_member_id
  belongs_to :second_member, class_name: 'User', foreign_key: :second_member_id

  validates_inclusion_of :status, in: STATUSES
  validates_presence_of  :status, :tag, :first_member, :second_member, :final_date
end
