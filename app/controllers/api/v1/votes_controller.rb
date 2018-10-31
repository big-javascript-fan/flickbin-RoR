class Api::V1::VotesController < Api::V1::BaseController
  before_action :authenticate_user!

  def create
    video = get_video
    vote_value  = get_vote_value

    video.transaction do
      video_tag   = video.tag
      video_owner = video.user

      video.votes.create!(voter_id: current_user.id, value: vote_value)
      video.update!(votes_amount: video.votes_amount + vote_value)
      video_tag.update!(votes_amount: video_tag.votes_amount + vote_value)
      video_owner.update!(rank: video_owner.rank + vote_value)
    end

    render json: { new_votes_amount_for_video: video.votes_amount }
  rescue => e
    render_error(422, 'NotValid', e)
  end

  def update
    video = get_video
    new_vote_value = get_vote_value

    video.transaction do
      video_tag   = video.tag
      video_owner = video.user
      prev_vote = Vote.find_by!(voter_id: current_user.id, video_id: video.id)

      new_votes_amount_for_video = video.votes_amount - prev_vote.value + new_vote_value
      new_votes_amount_for_tag = video_tag.votes_amount - prev_vote.value + new_vote_value
      new_rank_for_video_owner = video_owner.rank - prev_vote.value + new_vote_value

      prev_vote.update!(value: new_vote_value)
      video.update!(votes_amount: new_votes_amount_for_video)
      video_tag.update!(votes_amount: new_votes_amount_for_tag)
      video_owner.update!(rank: new_rank_for_video_owner)
    end

    render json: { new_votes_amount_for_video: video.votes_amount }
  rescue => e
    render_error(422, 'NotValid', e)
  end

  def destroy
    video = get_video

    video.transaction do
      video_tag   = video.tag
      video_owner = video.user
      prev_vote = Vote.find_by!(voter_id: current_user.id, video_id: video.id)

      new_votes_amount_for_video = video.votes_amount - prev_vote.value
      new_votes_amount_for_tag = video_tag.votes_amount - prev_vote.value
      new_rank_for_video_owner = video_owner.rank - prev_vote.value

      prev_vote.destroy!
      video.update!(votes_amount: new_votes_amount_for_video)
      video_tag.update!(votes_amount: new_votes_amount_for_tag)
      video_owner.update!(rank: new_rank_for_video_owner)
    end

    render json: { new_votes_amount_for_video: video.votes_amount }
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
