class Api::V1::CommentsController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:create]

  def create
    video = get_video
    comment = video.comments.build(
      commentator_id: current_user.id,
      message: params[:message],
      parent_id: params[:parent_id]
    )

    if comment.save
      render json: Api::V1::Comments::ShowSerializer.new(comment).call
    else
      render json: comment.errors.messages, status: 422
    end
  end

  def index
    video = get_video
    comments = Comment.includes(:commentator)
                      .where(video_id: video.id)
                      .page(params[:page])
                      .per(10)
    render json: Api::V1::Comments::IndexSerializer.new(comments).call
  end

  private

  def get_video
    @video ||= Video.friendly.find(params[:video_slug])
  end
end
