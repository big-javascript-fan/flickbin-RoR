# frozen_string_literal: true

class Api::V1::GroupedTagsController < Api::V1::BaseController
  def index
    sidebar_tags = get_sidebar_tags(70)
    tags = Tag.order(first_character: :asc)

    tags = tags.where(first_character: params[:first_char]&.first) if params[:first_char].present?

    tags = tags.where('title ILIKE ?', "%#{params[:query]}%") if params[:query].present?

    sidebar_tags_hash = sidebar_tags.map { |tag| { id: tag.id, slug: tag.slug, title: tag.title } }
    grouped_tags = tags.select(:id, :slug, :title, :first_character)
                       .page(params[:page])
                       .per(200)
                       .group_by(&:first_character)

    render json: Oj.dump(
      sidebar_tags: sidebar_tags_hash,
      grouped_tags: grouped_tags
    )
  end
end
