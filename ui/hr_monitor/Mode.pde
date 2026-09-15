int MODE_FITNESS = 0;
int MODE_CALM = 1;
int MODE_STRESSED = 2;

int currentMode = MODE_CALM;
int modeStartMillis = 0;

String modeLabel(int mode) {
  if (mode == MODE_FITNESS) return "FITNESS";
  if (mode == MODE_CALM) return "CALM";
  return "STRESSED";
}

color modeColor(int mode) {
  if (mode == MODE_FITNESS) return ZONE_HARD;
  if (mode == MODE_CALM) return ZONE_LIGHT;
  return ZONE_MAX;
}

void setMode(int mode) {
  currentMode = mode;
  modeStartMillis = millis();
}

void cycleMode() {
  setMode((currentMode + 1) % 3);
}

void drawModeBadge() {
  float badgeW = 220;
  float badgeH = 60;
  float badgeX = chartX + chartW - badgeW - 16;
  float badgeY = chartY + 16;

  noStroke();
  fill(CARD_BG);
  rect(badgeX, badgeY, badgeW, badgeH, CARD_RADIUS);

  fill(modeColor(currentMode));
  circle(badgeX + 26, badgeY + 22, 14);

  fill(255);
  textAlign(LEFT, CENTER);
  textSize(20);
  text(modeLabel(currentMode), badgeX + 46, badgeY + 20);

  fill(TEXT_MUTED);
  textSize(13);
  text("press 'm' to cycle", badgeX + 26, badgeY + 44);
}
