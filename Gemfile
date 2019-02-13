source 'https://rubygems.org'
ruby '2.5.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.6'
gem 'puma', '~> 3.7'
gem 'pg'
gem 'sassc-rails'
gem 'autoprefixer-rails', '~> 7.1', '>= 7.1.6'
gem 'jquery-rails', '~> 4.3.1'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks', '~> 5'
gem 'devise'
gem 'activeadmin'
gem 'activeadmin_addons'
gem 'activeadmin_json_editor', '~> 0.0.7'
gem 'lograge'
gem 'friendly_id', '~> 5.2.0'
gem 'babosa'
gem 'simple_form'
gem 'carrierwave', '~> 1.0'
gem 'fog-aws'
gem 'mini_magick'
gem 'yt', '~> 0.28.0'
gem 'rest-client'
gem 'awesome_print'
gem 'kaminari'
gem 'oj'
gem 'ancestry'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'
gem 'buffer', :github => 'bufferapp/buffer-ruby'
gem 'exception_notification'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'dotenv-rails'
  gem 'binding_of_caller'
  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'rspec-html-matchers'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors'
  gem 'pry-rails'
end
