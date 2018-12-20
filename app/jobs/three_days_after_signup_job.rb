class ThreeDaysAfterSignupJob < ApplicationJob
  queue_as :mailers

  def perform(user_id)
    user = User.find_by_id(user_id)
    if user.present? && user.confirmed_at.blank?
      user.send_confirmation_instructions
    end
  end
end
