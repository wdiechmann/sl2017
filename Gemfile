source 'https://rubygems.org'
source 'https://rails-assets.org'
ruby '2.1.2'
gem 'rails', '4.2.0'
gem 'rails-i18n', '~> 4.0.0'
gem 'roadie-rails'
gem 'bootstrap-material-design'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development
gem 'bootstrap-sass'
gem 'devise'
gem 'devise_invitable'
gem 'haml-rails'
gem 'mysql2'
gem 'pundit'
gem 'simple_form'
gem 'upmin-admin'
gem 'dotenv-rails'
gem 'masonry-rails'
gem 'ancestry'
gem 'delayed_job_active_record'
gem 'paper_trail', '~> 4.0.0.beta'
gem 'rdiscount'

gem 'rails-assets-typeahead.js'
gem 'rails-assets-handlebars'

group :production do
  gem "unicorn"
end
group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_21]
  gem 'tzinfo-data'
  gem 'bcrypt-ruby', :require => 'bcrypt'
  gem 'capistrano', '~> 3.3.5'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-rails-console'
  gem 'capistrano-rbenv', '~> 2.0'
  # cap tasks to manage puma application server
  # gem 'capistrano-puma', require: false
  #
  # see implementation here: https://github.com/capistrano/maintenance
  gem 'capistrano-maintenance', github: "capistrano/maintenance", require: false
  #
  gem 'html2haml'
  gem 'hub', :require=>nil
  gem 'quiet_assets'
  gem 'rails_layout'
  gem "pry"
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
end
group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
end
