# frozen_string_literal: true

class Video
  class ObjectsForHomePageQuery < ApplicationQuery
    def initialize(args)
      @limit = args.dig(:limit)
      @offset = args.dig(:offset)
    end

    def call
      videos = VideoForHomePage.where.not(cover: nil).order('id desc')
      videos = videos.limit(@limit) unless @limit.nil?
      videos = videos.offset(@offset) unless @offset.nil?
      videos
    end
  end
end
