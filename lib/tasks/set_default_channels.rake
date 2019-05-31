# frozen_string_literal: true

namespace :user do
  desc 'set default channels'
  # example of task launch - rake user:set_default_channels
  task set_default_channels: :environment do
    User.where.not(confirmed_at: nil).find_each do |u|
      User::AutoSubscriptionService.call(u)
    end
  end
end
