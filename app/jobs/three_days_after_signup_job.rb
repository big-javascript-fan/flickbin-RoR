# frozen_string_literal: true

class ThreeDaysAfterSignupJob < ApplicationJob
  queue_as :mailers

  def perform(user_id)
    user = User.find_by_id(user_id)
    user.send_confirmation_instructions if user.present? && user.confirmed_at.blank?
  end
end
