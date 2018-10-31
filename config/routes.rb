require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :api do
    namespace :v1 do
      namespace :home do
        get '/', action: :index
      end

      scope module: :users do
        get 'users/:channel_slug', action: :show

        scope module: :avatars do
          put 'avatars', action: :update
        end
      end

      scope module: :tags do
        get  'tags/:tag_slug', action: :show
        get  'tags',          action: :index
        post 'tags',          action: :create
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
    end
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    confirmations: 'users/confirmations'
  }

  scope module: :tags do
    get  'tags/new',       action: :new
    get  'tags',           action: :index
    get  'tags/:tag_slug', action: :show, as: :tag
    post 'tags',           action: :create
  end

  scope module: :videos do
    get    'videos/new',         action: :new
    get    'videos/:video_slug', action: :show,   as: :video
    post   'videos/new',         action: :create, as: :create_video
    delete 'videos/:video_slug', action: :destroy
  end

  get  'stations/:channel_slug' => 'users#show', as: :station

  root 'home#index'
end
