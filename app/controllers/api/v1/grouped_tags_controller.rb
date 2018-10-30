class Api::V1::GroupedTagsController < Api::V1::BaseController
  def index
    sidebar_tags = get_sidebar_tags(30)
    tags = Tag.order(first_character: :asc)

    if params[:first_char].present?
      tags = tags.where(first_character: params[:first_char]&.first)
    end

    if params[:query].present?
      tags = tags.where('title ILIKE ?', "%#{params[:query]}%")
    end

    sidebar_tags_hash = sidebar_tags.map { |tag| {id: tag.id, slug: tag.slug, title: tag.title} }
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
