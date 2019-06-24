# frozen_string_literal: true

module Broadcast
  class HomePageService < ApplicationService
    def initialize(action, **params)
      @params = params.merge(action: action)
    end

    def call
      ActionCable.server.broadcast 'home_page', @params
    end
  end
end
