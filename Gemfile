# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

gem 'rails', '~> 5.2.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.12'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'graphql', '1.9.4'
gem 'simple_command'
gem 'graphql-errors'
gem 'activerecord-import'
gem 'rack-cors', require: 'rack/cors'
gem 'redis-rails'
gem 'jwt'
gem 'bcrypt', '3.1.12'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker', '~> 1.8', '>= 1.8.7'
  gem 'rspec-rails', '~> 3.8'
  gem 'shoulda-matchers'
  gem 'rspec-graphql_matchers'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
