# frozen_string_literal: true

class User
  class AutoSubscriptionService < ApplicationService
    DEFAULT_CHANNELS = %w[
      birdy mattTV
    ].freeze

    def initialize(user)
      @user = user
    end

    def call
      User.where(
        channel_name: self.class::DEFAULT_CHANNELS
      ).each { |u| @user.subscribe(u) }
    end
  end
end
