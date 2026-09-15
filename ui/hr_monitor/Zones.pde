int age = 25;
int maxHR = 220 - age;

float pctOfMax(float bpm) {
  return bpm / maxHR * 100;
}

color zoneColorFor(float bpm) {
  float pct = pctOfMax(bpm);

  if (pct < 60) return ZONE_VLIGHT;
  if (pct < 70) return ZONE_LIGHT;
  if (pct < 80) return ZONE_MOD;
  if (pct < 90) return ZONE_HARD;
  return ZONE_MAX;
}
