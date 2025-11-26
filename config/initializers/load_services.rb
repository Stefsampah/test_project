# Charger explicitement les services
Dir[Rails.root.join('app/services/**/*.rb')].each { |f| require f }

