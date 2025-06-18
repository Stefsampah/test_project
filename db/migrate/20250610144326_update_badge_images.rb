class UpdateBadgeImages < ActiveRecord::Migration[7.1]
  def up
    # Competitor badges
    execute <<-SQL
      UPDATE badges 
      SET image = 'dropmixpop.webp'
      WHERE badge_type = 'competitor' AND level = 'bronze';
    SQL

    # Note: NFT.jpg n'existe pas encore, on utilise une image par défaut
    execute <<-SQL
      UPDATE badges 
      SET image = 'VIP-gold.jpg'
      WHERE badge_type = 'competitor' AND level = 'silver';
    SQL

    execute <<-SQL
      UPDATE badges 
      SET image = 'VIP-gold.jpg'
      WHERE badge_type = 'competitor' AND level = 'gold';
    SQL

    # Engager badges
    execute <<-SQL
      UPDATE badges 
      SET image = 'pandora-playlist-collage.webp'
      WHERE badge_type = 'engager' AND level = 'bronze';
    SQL

    execute <<-SQL
      UPDATE badges 
      SET image = 'photos-dedicacees.jpeg'
      WHERE badge_type = 'engager' AND level = 'silver';
    SQL

    # Note: concert-virtuel.jpg n'existe pas encore, on utilise concert.jpeg
    execute <<-SQL
      UPDATE badges 
      SET image = 'concert.jpeg'
      WHERE badge_type = 'engager' AND level = 'gold';
    SQL

    # Critic badges
    # Note: Best-Music.webp n'existe pas encore, on utilise photos-dedicacees.jpeg
    execute <<-SQL
      UPDATE badges 
      SET image = 'photos-dedicacees.jpeg'
      WHERE badge_type = 'critic' AND level = 'bronze';
    SQL

    # Note: artist_message.jpeg n'existe pas encore, on utilise photos-dedicacees.jpeg
    execute <<-SQL
      UPDATE badges 
      SET image = 'photos-dedicacees.jpeg'
      WHERE badge_type = 'critic' AND level = 'silver';
    SQL

    # Note: backstage_virtuel.jpg n'existe pas encore, on utilise interview.jpg
    execute <<-SQL
      UPDATE badges 
      SET image = 'interview.jpg'
      WHERE badge_type = 'critic' AND level = 'gold';
    SQL

    # Challenger badges
    # Note: Exclusive_content.jpeg n'existe pas encore, on utilise photos-dedicacees.jpeg
    execute <<-SQL
      UPDATE badges 
      SET image = 'photos-dedicacees.jpeg'
      WHERE badge_type = 'challenger' AND level = 'bronze';
    SQL

    # Note: music_merch.jpeg n'existe pas encore, on utilise photos-dedicacees.jpeg
    execute <<-SQL
      UPDATE badges 
      SET image = 'photos-dedicacees.jpeg'
      WHERE badge_type = 'challenger' AND level = 'silver';
    SQL

    execute <<-SQL
      UPDATE badges 
      SET image = 'interview.jpg'
      WHERE badge_type = 'challenger' AND level = 'gold';
    SQL
  end

  def down
    execute "UPDATE badges SET image = NULL;"
  end
end 