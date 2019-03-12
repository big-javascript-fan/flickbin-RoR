class Battle < ApplicationRecord
  STATUSES = %w(active completed)

  belongs_to :tag

  validates_inclusion_of :kind_of, in: STATUSES
end
