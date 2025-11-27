#!/usr/bin/env ruby
# Script pour vérifier la configuration Cloudinary

puts "🔍 Vérification de la configuration Cloudinary..."
puts "=" * 80

# Vérifier les variables d'environnement
cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
api_key = ENV['CLOUDINARY_API_KEY']
api_secret = ENV['CLOUDINARY_API_SECRET']

puts "\n📋 Variables d'environnement:"
puts "  CLOUDINARY_CLOUD_NAME: #{cloud_name.present? ? '✅ Définie' : '❌ Manquante'}"
puts "  CLOUDINARY_API_KEY: #{api_key.present? ? '✅ Définie' : '❌ Manquante'}"
puts "  CLOUDINARY_API_SECRET: #{api_secret.present? ? '✅ Définie' : '❌ Manquante'}"

if cloud_name.blank? || api_key.blank? || api_secret.blank?
  puts "\n❌ Erreur: Les variables d'environnement Cloudinary ne sont pas toutes définies"
  puts "   Configurez-les avec:"
  puts "   heroku config:set CLOUDINARY_CLOUD_NAME=... -a tubenplay-app"
  puts "   heroku config:set CLOUDINARY_API_KEY=... -a tubenplay-app"
  puts "   heroku config:set CLOUDINARY_API_SECRET=... -a tubenplay-app"
  exit 1
end

# Vérifier la configuration Active Storage
puts "\n📦 Configuration Active Storage:"
storage_service = Rails.application.config.active_storage.service
puts "  Service actif: #{storage_service}"

if storage_service != :cloudinary
  puts "  ⚠️  Attention: Le service Active Storage n'est pas configuré pour Cloudinary"
  puts "     Vérifiez config/environments/#{Rails.env}.rb"
else
  puts "  ✅ Service Cloudinary configuré"
end

# Vérifier les gems
puts "\n💎 Gems installés:"
begin
  require 'cloudinary'
  puts "  ✅ cloudinary gem installé"
rescue LoadError
  puts "  ❌ cloudinary gem manquant - exécutez: bundle install"
end

begin
  require 'activestorage/cloudinary/service'
  puts "  ✅ activestorage-cloudinary-service gem installé"
rescue LoadError
  puts "  ❌ activestorage-cloudinary-service gem manquant - exécutez: bundle install"
end

# Vérifier les avatars existants
puts "\n👤 Avatars des utilisateurs:"
users_with_avatar = User.where(id: ActiveStorage::Attachment.where(name: 'avatar').select(:record_id)).count
users_total = User.count

puts "  Utilisateurs avec avatar: #{users_with_avatar} / #{users_total}"

if users_with_avatar > 0
  sample_user = User.joins(:avatar_attachment).first
  if sample_user&.avatar&.attached?
    begin
      url = sample_user.avatar.url
      puts "  ✅ Exemple d'avatar: #{sample_user.email}"
      puts "     URL: #{url}"
      if url.include?('cloudinary.com')
        puts "     ✅ Stocké sur Cloudinary"
      else
        puts "     ⚠️  Pas encore sur Cloudinary (nécessite réimport)"
      end
    rescue => e
      puts "  ⚠️  Erreur lors de la vérification: #{e.message}"
    end
  end
end

puts "\n" + "=" * 80
puts "✅ Vérification terminée!"
puts "\n💡 Prochaines étapes:"
puts "   1. Si les variables d'environnement manquent, configurez-les sur Heroku"
puts "   2. Si les gems manquent, exécutez: bundle install"
puts "   3. Pour réimporter les avatars: ./import_avatars_to_heroku_final.sh"

