class TestMailingJob < ApplicationJob
  queue_as :mailers

  def perform
    ApplicationMailer::test_mailing.deliver_now
  end
end
