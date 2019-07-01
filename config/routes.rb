require 'sidekiq/web'

Rails.application.routes.draw do
  get 'tv', to: 'tv#index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  authenticate :user, lambda { |u| u.sidekiq_manager? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      namespace :home do
        get '/', action: :index
      end

      namespace :exceptions do
        post '/', action: :create
      end

      scope module: :users do
        get 'users/:channel_slug', action: :show

        scope module: :avatars do
          put 'users/avatars', action: :update
        end
      end

      scope module: :tags do
        get  'topics/:tag_slug', action: :show
        get  'topics',          action: :index
        post 'topics',          action: :create
      end

      scope module: :grouped_tags do
        get 'grouped_tags', action: :index
      end

      scope module: :votes do
        post   ':video_slug/votes', action: :create,  as: :create_vote
        put    ':video_slug/votes', action: :update,  as: :update_vote
        delete ':video_slug/votes', action: :destroy, as: :destroy_vote
      end

      scope module: :comments do
        get  ':video_slug/comments', action: :index
        post ':video_slug/comments', action: :create, as: :create_comment
      end

      scope module: :notifications do
        get 'notifications', action: :index
        put 'notifications', action: :update
      end

      scope module: :social_networks do
        get 'social_networks', action: :index
      end

      scope module: :youtube_channels do
        get 'youtube_channels', action: :index
      end
    end
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    confirmations: 'users/confirmations'
  }

  scope module: :tags do
    get  'topics/new',       action: :new
    get  'topics',           action: :index, as: :tags
    get  'topics/:tag_slug', action: :show, as: :tag
    post 'topics',           action: :create
  end

  scope module: :videos do
    get    'videos/new',         action: :new
    get    'videos/:video_slug', action: :show,   as: :video
    post   'videos/new',         action: :create, as: :create_video
    delete 'videos/:video_slug', action: :destroy
  end

  namespace :statics do
    get '/:page/', action: :show
  end

  get  'stations/:channel_slug' => 'users#show', as: :station

  root 'home#index'
end
