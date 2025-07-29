double calculateHitRate(int hits, int totalAttempts) {
  return (hits * 100) / totalAttempts;
}

int calculateScore(int hits, double hitRate) {
  // Base points: 10 points per hit
  int baseScore = hits * 10;

  // Accuracy bonus: multiply by accuracy factor
  double accuracyMultiplier = hitRate / 100;

  // Final score with accuracy bonus
  return (baseScore * (1 + accuracyMultiplier)).round();
}

String getRankTitle(int score) {
  if (score >= 500) return "God";
  if (score >= 400) return "Legend";
  if (score >= 350) return "Pro";
  if (score >= 300) return "Sharpshooter";
  if (score >= 200) return "Good Shot";
  if (score >= 100) return "Average";
  return "Needs Practice";
}
