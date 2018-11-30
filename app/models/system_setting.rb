class SystemSetting < ApplicationRecord
  after_save :update_scheduler

  def update_scheduler
    Sidekiq.set_schedule('wasp_post_job', {
      every: "#{self.data['startup_frequency_in_min_for_wasp_post']}m",
      class: 'WaspPostJob'
    })
  end
end
