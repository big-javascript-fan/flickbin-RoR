# frozen_string_literal: true

module TagsHelper
  def tag_heading_title
    "#{tag_title.upcase} on flickbin.tv"
  end

  def tag_title
    @tag.title
  end
end
