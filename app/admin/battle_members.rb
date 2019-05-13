# frozen_string_literal: true

ActiveAdmin.register BattleMember do
  permit_params :user_id, :youtube_channel_url, :twitter_account_name, :name, :photo_url

  controller do
    def create
      @resource = BattleMember.new(permitted_params[:battle_member])
      @resource.youtube_channel_guid = permitted_params.dig(:battle_member, :youtube_channel_url).split('/').last
      @resource.remote_photo_url = permitted_params.dig(:battle_member, :photo_url)

      if @resource.save
        flash[:notice] = 'Battle Member was successfully created!'
        redirect_to admin_battle_member_path(@resource)
      else
        render :new
      end
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :twitter_account_name
    column :youtube_channel_guid
    column :photo do |bm|
      image_tag(bm.photo.url || '/images/avatar_holder.jpg', width: 50, height: 50)
    end
    column :user_id do |bm|
      link_to(bm.user_id, admin_user_path(id: bm.user_id)) if bm.user_id.present?
    end
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :user_id, as: :search_select, url: admin_users_path, label: 'Flickbin station',
                        fields: [:channel_name], display_name: :channel_name, minimum_input_length: 2,
                        order_by: 'channel_name_asc'
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
        f.input :twitter_account_name
        f.input :name
        f.input :photo_url
      end
    end
    f.actions
  end

  filter :name
end
