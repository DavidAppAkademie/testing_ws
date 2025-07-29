/// returns the hit rate as a decimal (0.0 to 1.0)
double calculateHitRate(int hits, int totalAttempts) {
  return hits / totalAttempts;
}

/// calculates the score based on hits and hit rate
int calculateScore(int hits, double hitRate) {
  // Base points: 10 points per hit
  int baseScore = hits * 10;

  // Final score with accuracy bonus
  return (baseScore * (1 + hitRate)).round();
}

/// returns the rank title based on the score
String getRankTitle(int score) {
  if (score >= 500) return "God";
  if (score >= 400) return "Legend";
  if (score >= 350) return "Pro";
  if (score >= 300) return "Sharpshooter";
  if (score >= 200) return "Good Shot";
  if (score >= 100) return "Average";
  return "Needs Practice";
}
