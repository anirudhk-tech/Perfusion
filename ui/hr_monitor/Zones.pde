int age = 20;
int maxHR = 220 - age;

float pctOfMax(float bpm) {
  return bpm / maxHR * 100;
}

color zoneColorFor(float bpm) {
  if (bpm < 66) return ZONE_MAX;
  if (bpm < 72) return ZONE_HARD;
  if (bpm < 78) return ZONE_MOD;
  if (bpm < 84) return ZONE_VLIGHT;
  return ZONE_LIGHT;
}
