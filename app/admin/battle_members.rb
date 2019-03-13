ActiveAdmin.register BattleMember do
  permit_params :youtube_channel_id, :twitter_account, :station, :name, :avatar

  controller do
    def create
      youtube_url = params.dig(:battle_member, :youtube_url)
      response_body = RestClient.get(youtube_url).body
      twitter_account = response_body[/twitter.com\/#!\/([A-Za-z0-9]+)/, 1]

      if twitter_account.present?
        youtube_channel_id = youtube_url[/channel\/(\w+)(\/|\?|\z)/, 1]
        if youtube_channel_id.present?
          channel = Yt::Channel.new id:(youtube_channel_id)
          battle_mamber = BattleMember.new(
            youtube_channel_id: youtube_channel_id,
            name: channel.title
          )
        else

        end
      else

      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :youtube_url
      f.inputs do
        '<li class="string input optional stringish" id="battle_member_twitter_account_input">
          <label for="battle_member_twitter_account" class="label">Youtube url</label>
          <div class="battle_mamber-wrap">
            <input id="battle_member_twitter_account" type="text" name="battle_member[twitter_account]">
            <input type="submit" name="commit" value="Parse twitter from youtube channel" data-disable-with="Parse twitter from youtube channel">
          </div>
        </li>'.html_safe
        # f.button :parse_twitter_from_youtube_channel_page
      end
    end
    f.actions
  end

  filter :name
end
