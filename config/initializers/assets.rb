# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w(
  specific_by_templates/login.js
  specific_by_templates/sign_up.js
  specific_by_templates/station.js
  specific_by_templates/new_video.js
  specific_by_templates/home.js
  specific_by_templates/all_tags.js
  specific_by_templates/specific_tag.js
  specific_by_templates/specific_video.js
  specific_by_templates/trending_tags_bar.js
)
