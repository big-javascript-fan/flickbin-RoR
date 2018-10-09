Rails.application.routes.draw do
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
    get  'videos/new',         action: :new
    get  'videos',             action: :index
    get  'videos/:video_slug', action: :show, as: :video
    post 'videos',             action: :create
  end

  get  'stations/:channel_slug' => 'users#show', as: :station

  root 'home#index'
end
