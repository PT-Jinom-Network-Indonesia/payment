distanceConverter(int jarak) {
  if (jarak > 999) {
    return "${(jarak / 1000).toStringAsFixed(1)} km";
  }

  return "$jarak m";
}
