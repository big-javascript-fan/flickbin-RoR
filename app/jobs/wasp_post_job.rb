class WaspPostJob < ApplicationJob
  queue_as :rank_calculation

  def perform(*args)
    Sidekiq.set_schedule('wasp_post_job', {
      every: "#{SystemSetting.last.data['startup_frequency_in_min_for_wasp_post']}m",
      class: 'WaspPostJob'
    })

    WaspPostService.new.call
  rescue => e
    ExceptionLogger.create(source: 'WaspPostJob#perform', message: e)
    ExceptionNotifier.notify_exception(e, data: { source: 'WaspPostJob#perform' })
  end
end
