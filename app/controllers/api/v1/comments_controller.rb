# frozen_string_literal: true

class Api::V1::CommentsController < Api::V1::BaseController
  include ActionView::Helpers::DateHelper
  before_action :authenticate_user!, only: [:create]

  def create
    video = get_video
    comment = video.comments.build(
      commentator_id: current_user.id,
      message: params[:message],
      parent_id: params[:parent_id]
    )

    if comment.save
      if video.user.email != current_user.email
        ::Notifications::AfterCommentService.new(comment.id, is_reply_comment: params[:parent_id].present?).call
      end
      render json: Api::V1::Comments::ShowSerializer.new(comment).call
    else
      render json: comment.errors.messages, status: 422
    end
  rescue StandardError => e
    ExceptionLogger.create(source: 'Api::V1::CommentsController#create', message: e, params: params)
    ExceptionNotifier.notify_exception(e, env: request.env, data: { source: 'Api::V1::CommentsController#create' })
  end

  def index
    sidebar_tags = get_sidebar_tags
    video = get_video
    comments = video.comments
                    .roots
                    .includes(:commentator)
                    .order(created_at: :desc)
                    .page(params[:page])
                    .per(6)

    sidebar_tags_hash = sidebar_tags.map { |tag| { id: tag.id, slug: tag.slug, title: tag.title } }

    comments_tree = comments.map do |comment|
      comment.subtree(to_depth: 1).arrange_serializable(order: { created_at: :desc }) do |root_comment, child_comments|
        comments_tree_to_hash(root_comment, child_comments)
      end
    end

    render json: Oj.dump(
      sidebar_tags: sidebar_tags_hash,
      comments_tree: comments_tree.flatten
    )
  end

  private

  def get_video
    @video ||= Video.friendly.find(params[:video_slug])
  end

  def comments_tree_to_hash(root_comment, child_comments)
    {
      id: root_comment.id,
      parent_id: root_comment.parent_id,
      message: root_comment.message,
      post_time: time_ago_in_words(root_comment.created_at),
      commentator: commentator_to_hash(root_comment.commentator),
      child_comments: child_comments
    }
  end

  def commentator_to_hash(commentator)
    {
      id: commentator.id,
      channel_name: commentator.channel_name,
      avatar: commentator.avatar.thumb_44x44.url
    }
  end
end
