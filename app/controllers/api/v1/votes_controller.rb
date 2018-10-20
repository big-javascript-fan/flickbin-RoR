class Api::V1::VotesController < Api::V1::BaseController
  before_action :authenticate_user!

  def create
    user_who_got_voice = User.friendly.find(params[:channel_slug])
    value = params[:value].to_i.negative? ? -1 : 1

    user_who_got_voice.transaction do
      user_who_got_voice.votes.create(value: value, voter_id: current_user.id)
      new_rank = user_who_got_voice.rank + value
      user_who_got_voice.update(rank: new_rank)
    end

    render json: { new_rank: user_who_got_voice.rank }
  rescue => e
    render_error(422, 'NotValid', e)
  end

  def update
    user_who_got_voice = User.friendly.find(params[:channel_slug])
    new_vote_value = params[:value].to_i.negative? ? -1 : 1

    user_who_got_voice.transaction do
      vote = Vote.find_by!(voter_id: current_user.id, user_id: user_who_got_voice.id)
      old_vote_value = vote.value

      if(new_vote_value != old_vote_value)
        new_rank = user_who_got_voice.rank - old_vote_value + new_vote_value
        user_who_got_voice.update(rank: new_rank)
      end
    end

    render json: { new_rank: user_who_got_voice.rank }
  rescue => e
    render_error(422, 'NotValid', e)
  end
end
