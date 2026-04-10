namespace :gameplay do
  desc "Backfill journey/season points from existing swipes (DRY_RUN=1 by default, APPLY=1 to persist)"
  task backfill_journey_points: :environment do
    dry_run = ENV["APPLY"].to_s != "1"
    target_email = ENV["USER_EMAIL"].to_s.strip.downcase
    limit = ENV["LIMIT"].to_i

    users_scope =
      if target_email.present?
        user = User.find_by(email: target_email)
        if user.nil?
          abort "USER_EMAIL not found: #{target_email}"
        end
        User.where(id: user.id)
      else
        User.all
      end

    users_scope = users_scope.limit(limit) if limit.positive?

    puts "Mode: #{dry_run ? 'DRY_RUN' : 'APPLY'}"
    puts "Users targeted: #{users_scope.count}"

    processed = 0
    changed = 0

    users_scope.find_each do |user|
      processed += 1

      old_journey = user.journey_points.to_i
      old_season = user.season_journey_points.to_i
      old_link = !!user.season_concert_link_eligible
      old_ticket = !!user.season_concert_ticket_eligible

      block = proc do
        user.update_columns(
          journey_points: 0,
          season_journey_points: 0,
          season_concert_link_eligible: false,
          season_concert_ticket_eligible: false
        )

        swipes = Swipe.joins(:game).where(games: { user_id: user.id }).includes(:video).order(created_at: :asc, id: :asc)
        swipes.each do |swipe|
          video = swipe.video
          next if video.nil?
          JourneyPointsService.add_swipe_points(user, swipe, video)
        end

        user.reload
      end

      if dry_run
        ActiveRecord::Base.transaction do
          block.call
          raise ActiveRecord::Rollback
        end
      else
        block.call
      end

      user.reload
      new_journey = user.journey_points.to_i
      new_season = user.season_journey_points.to_i
      new_link = !!user.season_concert_link_eligible
      new_ticket = !!user.season_concert_ticket_eligible

      # In dry run, values are unchanged (rollback). Recompute preview in a rollbacked transaction.
      if dry_run
        preview_journey = old_journey
        preview_season = old_season
        preview_link = old_link
        preview_ticket = old_ticket

        ActiveRecord::Base.transaction do
          block.call
          user.reload
          preview_journey = user.journey_points.to_i
          preview_season = user.season_journey_points.to_i
          preview_link = !!user.season_concert_link_eligible
          preview_ticket = !!user.season_concert_ticket_eligible
          raise ActiveRecord::Rollback
        end

        if preview_journey != old_journey || preview_season != old_season || preview_link != old_link || preview_ticket != old_ticket
          changed += 1
          puts "[DRY] #{user.email} journey: #{old_journey} -> #{preview_journey}, season: #{old_season} -> #{preview_season}, link: #{old_link} -> #{preview_link}, ticket: #{old_ticket} -> #{preview_ticket}"
        end
      else
        if new_journey != old_journey || new_season != old_season || new_link != old_link || new_ticket != old_ticket
          changed += 1
          puts "[APPLY] #{user.email} journey: #{old_journey} -> #{new_journey}, season: #{old_season} -> #{new_season}, link: #{old_link} -> #{new_link}, ticket: #{old_ticket} -> #{new_ticket}"
        end
      end
    end

    puts "Processed users: #{processed}"
    puts "Users changed: #{changed}"
    puts(dry_run ? "No DB changes persisted (DRY_RUN)." : "Backfill persisted.")
  end
end
