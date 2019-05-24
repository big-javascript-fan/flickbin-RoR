# frozen_string_literal: true

module TagsHelper
  def tag_heading_title
    tag_title.to_s
  end

  def tag_title
    @tag.title
  end
end
