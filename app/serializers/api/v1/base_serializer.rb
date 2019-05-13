# frozen_string_literal: true

class Api::V1::BaseSerializer
  private

  def sidebar_tags_to_hash(tags)
    return [] if tags.blank?

    tags.map do |tag|
      {
        id: tag.id,
        title: tag.title,
        slug: tag.slug
      }
    end
  end
end
