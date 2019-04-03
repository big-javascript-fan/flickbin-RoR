# == Schema Information
#
# Table name: system_settings
#
#  id         :bigint(8)        not null, primary key
#  data       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SystemSetting < ApplicationRecord
  after_save :update_scheduler

  def update_scheduler
    Sidekiq.set_schedule('wasp_post_job', {
      every: "#{self.data['startup_frequency_in_min_for_wasp_post']}m",
      class: 'WaspPostJob'
    })
  end
end
