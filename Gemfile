source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.5'

gem 'pg', '~> 0.18.4'

# Asset stuff
gem 'coffee-rails', '~> 4.1.0' # Use CoffeeScript for .coffee assets and views
gem 'jquery-rails', '~> 4.0.5' # Use jquery as the JavaScript library
gem 'sass-rails', '~> 5.0' # Use SCSS for stylesheets
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets

# Comic stuff
gem 'carrierwave', '~> 0.10.0'
gem 'fog', '~> 1.37.0'
gem 'mini_magick', '~> 4.3.6'

# Other mess
gem 'devise', '~> 3.5.3'

# To migrate over current comics
gem 'watir', '~> 5.0.0', require: false

group :development, :test do
  gem 'byebug'
end

group :development do
  gem 'spring'
end

group :production do
  gem 'rails_12factor'
end
