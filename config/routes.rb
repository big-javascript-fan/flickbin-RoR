Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      scope module: :tags do
        get  'tags', action: :index
        post 'tags', action: :create
      end

      namespace :home do
        scope module: :tags do
          get 'tags', action: :index
        end

        scope module: :videos do
          get 'videos', action: :index
        end
      end
    end
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
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
    get    'videos/:video_slug', action: :show, as: :video
    post   'videos/new',         action: :create, as: :create_video
    delete 'videos/:video_slug', action: :destroy
  end

  get  'stations/:channel_slug' => 'users#show', as: :station

  root 'home#index'
end
