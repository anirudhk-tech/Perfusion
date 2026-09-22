float msInVLight = 0;
float msInLight = 0;
float msInMod = 0;
float msInHard = 0;
float msInMax = 0;

int lastZoneUpdateMillis = 0;
boolean zoneTimingStarted = false;

void updateTimeInZone(float bpm) {
  if (!zoneTimingStarted) {
    lastZoneUpdateMillis = millis();
    zoneTimingStarted = true;
    return;
  }

  int now = millis();
  float dt = now - lastZoneUpdateMillis;
  lastZoneUpdateMillis = now;

  float pct = pctOfMax(bpm);

  if (pct < 60) msInVLight += dt;
  else if (pct < 70) msInLight += dt;
  else if (pct < 80) msInMod += dt;
  else if (pct < 90) msInHard += dt;
  else msInMax += dt;
}

float totalActiveMs() {
  return msInVLight + msInLight + msInMod + msInHard + msInMax;
}

void drawTimeInZone() {
  float total = totalActiveMs();
  if (total <= 0) total = 1;

  cardLabel("TIME IN ZONE", zoneX + 24, zoneY + 20);

  int totalSec = int(total / 1000);
  fill(ACCENT_PRIMARY);
  textSize(14);
  textAlign(RIGHT, TOP);
  text("Active: " + totalSec + "s", zoneX + zoneW - 24, zoneY + 20);

  String[] labels = {"Very Light", "Light", "Moderate", "Hard", "Maximum"};
  float[] values = {msInVLight, msInLight, msInMod, msInHard, msInMax};
  color[] colors = {ZONE_VLIGHT, ZONE_LIGHT, ZONE_MOD, ZONE_HARD, ZONE_MAX};

  int barX = int(zoneX + 24);
  int barW = int(zoneW - 48);
  int barH = 20;
  int barGap = 12;
  int barY = int(zoneY + 50);

  textAlign(LEFT, CENTER);
  for (int i = 0; i < labels.length; i++) {
    float frac = values[i] / total;
    float w = frac * barW;

    noStroke();
    fill(255, 255, 255, 15);
    rect(barX, barY, barW, barH, 6);

    fill(colors[i]);
    rect(barX, barY, w, barH, 6);

    fill(255);
    textSize(12);
    text(labels[i] + "  " + int(values[i] / 1000) + "s", barX + 10, barY + barH / 2);

    barY += barH + barGap;
  }
}
