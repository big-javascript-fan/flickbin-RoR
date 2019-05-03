# frozen_string_literal: true

class TweetBattleService
  include Rails.application.routes.url_helpers

  def initialize(battle)
    default_url_options[:host] = ActionMailer::Base.asset_host
    @battle = battle
  end

  def call
    return if ENV['BUFFER_ACCESS_TOKEN'].blank?

    client = Buffer::Client.new(ENV['BUFFER_ACCESS_TOKEN'])
    client.create_update(
      body: {
        text: message_builder,
        profile_ids: [ENV['BUFFER_TWITTER_PROFILE_ID']]
      }
    )
  end

  private

  def message_builder
    case Rails.env
    when 'production', 'staging'
      battle_url = battle_url(@battle)
    else
      battle_url = battle_url(@battle.id)
    end

    "A battle has begun! This battle, a popularity contest, is between two incredible creators, @#{@battle.first_member.twitter_account_name} vs. @#{@battle.second_member.twitter_account_name} in the flickbin \##{@battle.tag.title.capitalize} topic. If you’re a fan, go vote/share to show your support before time runs out! #{battle_url}"
  end
end
