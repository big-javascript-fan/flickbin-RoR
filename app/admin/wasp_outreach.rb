ActiveAdmin.register Video, as: 'WASP Outreach' do
  permit_params :url, :tag_id, :twitter_handle
  menu label: 'WASP Outreach'

  controller do
    def scoped_collection
      super.where(wasp_outreach: true)
    end

    def create
      user_id = User.where(role: 'dummy').sample.id
      tag_id = permitted_params[:video][:tag_id]
      video_url = permitted_params[:video][:url]
      youtube_video_id = VideoHelper.get_video_id_form_youtube_url(video_url)

      if tag_id.blank? || youtube_video_id.blank?
        flash[:error] = "Tag and video url must be present"
        return redirect_to new_admin_wasp_outreach_path
      elsif Video.active.tagged.exists?(source_id: youtube_video_id, tag_id: tag_id)
        @resource = Video.active.tagged.where(source_id: youtube_video_id, tag_id: tag_id).first
        @resource.wasp_outreach = true
      else
        additional_params = {
          user_id: user_id,
          wasp_outreach: true
        }

        @resource = Video.new(permitted_params[:video].merge(additional_params))
      end

      if @resource.save
        WaspOutreachJob.perform_later(@resource.id)
        TwitterPostingJob.perform_later(@resource.id)
        flash[:notice] = "Video was successfully added!"
        redirect_to admin_wasp_outreach_path(@resource)
      else
        flash[:error] = @resource.errors.messages[:invalid_url].first
        redirect_to new_admin_wasp_outreach_path
      end
    end
  end

  index do
    selectable_column
    id_column
    column :title
    column :url
    column :tag
    column :user
    column :wasp_outreach
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :url, label: 'Video url'
      f.input :tag_id, as: :search_select, url: admin_tags_path,
                    fields: [:title], display_name: 'title', minimum_input_length: 2,
                    order_by: 'title_asc'
      f.input :twitter_handle
    end
    f.actions
  end

  filter :title
  filter :url
  filter :tag
  filter :user, as: :select, collection: proc { User.all.map { |c| [c.email, c.id] } }
end
