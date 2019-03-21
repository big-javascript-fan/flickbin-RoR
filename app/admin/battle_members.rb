ActiveAdmin.register BattleMember do
  permit_params :youtube_channel_id, :twitter_account, :channel_title, :channel_avatar_url, :station_title

  controller do
    def create
      @resource = BattleMember.new(permitted_params[:battle_member])
      @resource.remote_channel_avatar_url = permitted_params.dig(:battle_member, :channel_avatar_url)

      if @resource.save
        flash[:notice] = "Battle Member was successfully created!"
        redirect_to admin_battle_member_path(@resource)
      else
        flash[:error] = @resource.errors.messages[:invalid_url].first
        redirect_to new_admin_battle_member_path
      end
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
        f.input :channel_avatar_url
        f.input :station_title
      end
    end
    f.actions
  end

  filter :name
end
