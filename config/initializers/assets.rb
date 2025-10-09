# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join("app/assets/builds")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( application.tailwind.css tailwind.css )
Rails.application.config.assets.precompile += %w( badge_service.js )
Rails.application.config.assets.precompile += %w( reward_animations.js )
Rails.application.config.assets.precompile += %w( controllers/badge_reveal_controller.js )
Rails.application.config.assets.precompile += %w( controllers/badges_controller.js )
Rails.application.config.assets.precompile += %w( controllers/hello_controller.js )
Rails.application.config.assets.precompile += %w( controllers/index.js )
Rails.application.config.assets.precompile += %w( logo/Copilot_20251006_162220.png )
