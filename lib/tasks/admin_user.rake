namespace :admin do
  desc "Create or update admin user safely (idempotent)"
  task upsert_user: :environment do
    email = ENV["EMAIL"].to_s.strip.downcase
    password = ENV["PASSWORD"].to_s
    username = ENV["USERNAME"].to_s.strip

    if email.blank?
      abort "Missing EMAIL. Example: rake admin:upsert_user EMAIL=admin@tubenplay.com PASSWORD='StrongPass123!'"
    end

    if password.blank? || password.length < 8
      abort "PASSWORD is required and must be at least 8 characters."
    end

    user = User.find_or_initialize_by(email: email)
    user.password = password
    user.password_confirmation = password
    user.username = username if username.present?
    user.admin = true

    if user.save
      puts "Admin upsert OK for #{user.email} (id=#{user.id}, admin=#{user.admin})"
    else
      abort "Failed: #{user.errors.full_messages.join(', ')}"
    end
  end
end
