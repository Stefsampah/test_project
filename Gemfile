ruby "3.3.5"
source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.5'

# The original asset pipeline for Rails
gem "sprockets-rails"

# Use Importmap for JavaScript dependencies
gem "importmap-rails"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 2.7"

# Use the Puma web server
gem "puma", "~> 4.3"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes navigating your web application faster
gem 'turbolinks', '~> 5'

# Build JSON APIs with ease
gem "jbuilder"

# Authentication
gem 'devise', '~> 4.8'

# YouTube API
gem 'google-api-client'

# Environment variables
gem 'dotenv-rails'

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# For logger support
gem 'logger', '~> 1.5.0'

group :development, :test do
  # Add a debugger
  gem 'byebug'
end

group :development do
  # Use console on exceptions pages
  gem "web-console"
end

group :test do
  # Use system testing
  gem "capybara"
  gem "selenium-webdriver", "~> 4.1.0"  # Version compatible avec Ruby 2.6
end
