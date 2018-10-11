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
gem 'jquery-rails', '~> 4.3.1'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks', '~> 5'
gem 'devise'
gem 'lograge'
gem 'friendly_id', '~> 5.2.0'
gem 'simple_form'
gem 'carrierwave', '~> 1.0'
gem 'mini_magick'
gem 'yt', '~> 0.28.0'
gem 'rest-client'
gem 'awesome_print'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'dotenv-rails'
  gem 'binding_of_caller'
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
