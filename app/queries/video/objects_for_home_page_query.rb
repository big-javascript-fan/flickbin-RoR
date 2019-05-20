# frozen_string_literal: true

class Video
  class ObjectsForHomePageQuery < ApplicationQuery
    def initialize(args)
      @limit = args.dig(:limit)
      @offset = args.dig(:offset)
    end

    def call
      videos = VideoForHomePage.all.order('id desc')
      # videos = Video.select('*')
      #      .where("v.wasp_post = 'f'")
      #      .from(Video.select('DISTINCT ON (source_id) source_id, *'), :v)
      #      .order('v.id desc')
      videos = videos.limit(@limit) unless @limit.nil?
      videos = videos.offset(@offset) unless @offset.nil?
      videos
    end
  end
end
