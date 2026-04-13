namespace :gameplay do
  desc "Weekly monitoring: top progression and users near 3000/6000 thresholds"
  task weekly_monitor: :environment do
    window = 7.days.ago..Time.current

    top_progress = User.includes(:swipes).map do |user|
      swipes = user.swipes.where(created_at: window)
      points = swipes.sum do |s|
        case s.action
        when "like" then 5
        when "dislike" then 1
        else 0
        end
      end
      { email: user.email, points: points, swipes: swipes.count, journey: user.journey_points.to_i }
    end.select { |r| r[:points].positive? }
       .sort_by { |r| -r[:points] }
       .first(10)

    near_3000 = User.where(journey_points: 2500...3000).order(journey_points: :desc).limit(10)
    near_6000 = User.where(journey_points: 5500...6000).order(journey_points: :desc).limit(10)

    puts "=== Weekly monitor (last 7 days) ==="
    puts "Top progression:"
    top_progress.each_with_index do |r, idx|
      puts "#{idx + 1}. #{r[:email]} | +#{r[:points]} pts | #{r[:swipes]} swipes | journey=#{r[:journey]}"
    end

    puts "\nNear 3000:"
    near_3000.each { |u| puts "- #{u.email}: #{u.journey_points}" }

    puts "\nNear 6000:"
    near_6000.each { |u| puts "- #{u.email}: #{u.journey_points}" }
  end

  desc "Fill empty playlist genres with simple keywords (DRY_RUN default, APPLY=1 to persist)"
  task fill_playlist_genres: :environment do
    dry_run = ENV["APPLY"].to_s != "1"
    updated = 0

    keyword_map = {
      "rap" => "rap",
      "drill" => "rap",
      "trap" => "rap",
      "afro" => "afro",
      "dancehall" => "dancehall",
      "electro" => "electro",
      "rock" => "rock",
      "pop" => "pop",
      "indie" => "indie"
    }

    fallback_cycle = %w[pop rap afro electro dancehall rock indie]
    fallback_index = 0

    scope = Playlist.where(genre: [nil, ""])
    puts "Mode: #{dry_run ? 'DRY_RUN' : 'APPLY'}"
    puts "Playlists sans genre: #{scope.count}"

    scope.find_each do |playlist|
      text = [playlist.title, playlist.description, playlist.category, playlist.subcategory]
             .compact.join(" ").downcase

      inferred = keyword_map.find { |k, _v| text.include?(k) }&.last
      inferred ||= fallback_cycle[fallback_index % fallback_cycle.length]
      fallback_index += 1

      updated += 1
      puts "#{dry_run ? '[DRY]' : '[APPLY]'} ##{playlist.id} #{playlist.title} -> #{inferred}"
      playlist.update_column(:genre, inferred) unless dry_run
    end

    puts "Playlists traitées: #{updated}"
    puts(dry_run ? "No DB changes persisted (DRY_RUN)." : "Genres persisted.")
  end
end
