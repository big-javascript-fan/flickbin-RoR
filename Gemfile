# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.5.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'activeadmin'
gem 'activeadmin_addons'
gem 'activeadmin_json_editor', '~> 0.0.7'
gem 'ancestry'
gem 'arctic_admin'
gem 'autoprefixer-rails', '~> 7.1', '>= 7.1.6'
gem 'awesome_print'
gem 'babosa'
gem 'buffer', github: 'bufferapp/buffer-ruby'
gem 'carrierwave', '~> 1.0'
gem 'devise'
gem 'exception_notification'
gem 'faker', git: 'https://github.com/stympy/faker.git', branch: 'master'
gem 'fog-aws'
gem 'friendly_id', '~> 5.2.0'
gem 'jquery-rails', '~> 4.3.1'
gem 'kaminari'
gem 'lograge'
gem 'mini_magick'
gem 'mini_racer', platforms: :ruby
gem 'nokogiri'
gem 'oj'
gem 'pg'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.6'
gem 'react_on_rails', '11.1.4'
gem 'rest-client'
gem 'sassc-rails'
gem 'scenic'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'simple_form'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', '~> 3'
gem 'yt', '~> 0.32.3'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'binding_of_caller'
  gem 'capybara', '~> 2.13'
  gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'guard-rspec'
  gem 'vcr'
  gem 'webmock'
  gem 'rspec-html-matchers'
  gem 'rspec-rails', '~> 3.8'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'annotate'
  gem 'better_errors'
  gem 'mailcatcher'
  gem 'pry-rails'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
