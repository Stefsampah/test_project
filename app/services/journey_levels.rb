# Parcours en 5 niveaux vers le concert (refonte gameplay).
# Seuils : 200, 600, 1200, 2000, 3000 points.
module JourneyLevels
  THRESHOLDS = [200, 600, 1200, 2000, 3000].freeze
  NAMES = {
    1 => "Découverte",
    2 => "Affinité",
    3 => "Fan potentiel",
    4 => "Fan confirmé",
    5 => "Concert débloqué"
  }.freeze

  class << self
    # Niveau actuel (1..5) à partir des journey_points
    def current_level(journey_points)
      journey_points = journey_points.to_i
      THRESHOLDS.each_with_index do |threshold, index|
        return index + 1 if journey_points < threshold
      end
      5
    end

    # Points nécessaires pour atteindre le prochain niveau (0 si niveau 5)
    def points_to_next_level(journey_points)
      level = current_level(journey_points)
      return 0 if level >= 5
      THRESHOLDS[level] - journey_points.to_i
    end

    # Seuil du niveau actuel (pour afficher "200 / 200" etc.)
    def threshold_for_level(level)
      return THRESHOLDS.last if level >= 5
      THRESHOLDS[level - 1] || 0
    end

    # Pourcentage vers le prochain niveau (0..100), ou 100 si niveau 5
    def progress_percentage(journey_points)
      level = current_level(journey_points)
      return 100 if level >= 5
      prev = level == 1 ? 0 : THRESHOLDS[level - 2]
      curr = journey_points.to_i
      threshold = THRESHOLDS[level - 1]
      range = threshold - prev
      return 0 if range <= 0
      (((curr - prev).to_f / range) * 100).round(1)
    end

    # Nom du niveau (pour l’UI)
    def level_name(level)
      NAMES[level] || "Niveau #{level}"
    end
  end
end
