Sidekiq.set_schedule('wasp_post_job', {
  every: "#{SystemSetting.last.data['startup_frequency_in_min_for_wasp_post']}m",
  class: 'WaspPostJob'
})
