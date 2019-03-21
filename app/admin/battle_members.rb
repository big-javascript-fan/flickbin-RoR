ActiveAdmin.register BattleMember do
  permit_params :youtube_channel_id, :twitter_account, :station, :name, :avatar

  controller do
    def create
      byebug
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :youtube_channel_url, required: true
      f.inputs do
        '<li class="string input optional stringish">
          <div class="battle_member-wrap">
            <input id="parse_youtube_channel_info" type="button" class="no-click" value="Parse info from youtube channel">
          </div>
        </li>
        <li class="string input optional stringish">
          <div id="channel_avatar_preview"></div>
        </li>'.html_safe
      end
      f.inputs do
        f.input :twitter_account
        f.input :channel_title
        f.input :channel_avatar, label: 'Channel avatar url'
        f.input :station_title
      end
    end
    f.actions
  end

  filter :name
end
