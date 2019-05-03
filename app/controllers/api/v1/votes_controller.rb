# frozen_string_literal: true

class Api::V1::VotesController < Api::V1::BaseController
  before_action :authenticate_user!

  def create
    video = get_video
    vote_value = get_vote_value

    video.transaction do
      video_owner = video.user
      video.votes.create!(voter_id: current_user.id, value: vote_value)

      if vote_value.positive?
        video.increment!(:positive_votes_amount)
        video_owner.increment!(:rank)
      else
        video.decrement!(:negative_votes_amount)
      end
    end

    render json: { new_votes_amount_for_video: video.votes_amount }
  rescue StandardError => e
    render_error(422, 'NotValid', e)
  end

  def update
    video = get_video
    new_vote_value = get_vote_value

    video.transaction do
      video_owner = video.user
      prev_vote = Vote.find_by!(voter_id: current_user.id, video_id: video.id)

      return if new_vote_value == prev_vote.value

      prev_vote.update!(value: new_vote_value)
      if new_vote_value.positive?
        video.increment!(:positive_votes_amount)
        video.increment!(:negative_votes_amount)
        video_owner.increment!(:rank)
      else
        video.decrement!(:positive_votes_amount)
        video.decrement!(:negative_votes_amount)
        video_owner.decrement!(:rank)
      end
    end

    render json: { new_votes_amount_for_video: video.votes_amount }
  rescue StandardError => e
    render_error(422, 'NotValid', e)
  end

  def destroy
    video = get_video

    video.transaction do
      video_owner = video.user
      prev_vote = Vote.find_by!(voter_id: current_user.id, video_id: video.id)

      if prev_vote.value.positive?
        video.decrement!(:positive_votes_amount)
        video_owner.decrement!(:rank)
      else
        video.increment!(:negative_votes_amount)
      end

      prev_vote.destroy!
    end

    render json: { new_votes_amount_for_video: video.votes_amount }
  rescue StandardError => e
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
