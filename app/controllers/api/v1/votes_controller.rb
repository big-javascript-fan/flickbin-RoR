class Api::V1::VotesController < Api::V1::BaseController
  before_action :authenticate_user!

  def create
    video = get_video
    video_owner = video.user
    vote_value = get_vote_value

    video_owner.transaction do
      video.votes.create!(voter_id: current_user.id, value: vote_value)
      video_owner.update!(rank: video_owner.rank + vote_value)
    end

    render json: { new_rank: video_owner.rank }
  rescue => e
    render_error(422, 'NotValid', e)
  end

  def update
    video = get_video
    video_owner = video.user
    new_vote_value = get_vote_value

    video_owner.transaction do
      vote = Vote.find_by!(voter_id: current_user.id, video_id: video.id)
      new_rank = video_owner.rank - vote.value + new_vote_value

      vote.update(value: new_vote_value)
      video_owner.update(rank: new_rank)
    end

    render json: { new_rank: video_owner.rank }
  rescue => e
    render_error(422, 'NotValid', e)
  end

  def destroy
    video = get_video
    video_owner = video.user

    video_owner.transaction do
      vote = Vote.find_by!(voter_id: current_user.id, video_id: video.id)
      new_rank = video_owner.rank - vote.value

      vote.destroy
      video_owner.update(rank: new_rank)
    end

    render json: { new_rank: video_owner.rank }
  rescue => e
    render_error(422, 'NotValid', e)
  end

  private

  def get_video
    @video ||= Video.friendly.find(params[:video_slug])
  end

  def get_vote_value
    @vote_value ||= params[:value].to_i.negative? ? -1 : 1
  end
end
