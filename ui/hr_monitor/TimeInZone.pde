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

  int panelX = 20;
  int panelY = height - 190;
  int panelW = 420;
  int panelH = 170;

  noStroke();
  fill(PANEL_COLOR);
  rect(panelX, panelY, panelW, panelH);

  fill(TEXT_MUTED);
  textAlign(LEFT, TOP);
  textSize(14);
  text("TIME IN ZONE", panelX + 15, panelY + 10);

  int totalSec = int(total / 1000);
  fill(ACCENT_PRIMARY);
  textSize(14);
  textAlign(RIGHT, TOP);
  text("Active: " + totalSec + "s", panelX + panelW - 15, panelY + 10);

  String[] labels = {"Very Light", "Light", "Moderate", "Hard", "Maximum"};
  float[] values = {msInVLight, msInLight, msInMod, msInHard, msInMax};
  color[] colors = {ZONE_MAX, ZONE_HARD, ZONE_MOD, ZONE_VLIGHT, ZONE_LIGHT};

  int barX = panelX + 15;
  int barW = panelW - 30;
  int barH = 18;
  int barGap = 10;
  int barY = panelY + 35;

  textAlign(LEFT, CENTER);
  for (int i = 0; i < labels.length; i++) {
    float frac = values[i] / total;
    float w = frac * barW;

    noStroke();
    fill(40, 40, 50);
    rect(barX, barY, barW, barH);

    fill(colors[i]);
    rect(barX, barY, w, barH);

    fill(255);
    textSize(12);
    text(labels[i] + "  " + int(values[i] / 1000) + "s", barX + 6, barY + barH / 2);

    barY += barH + barGap;
  }
}
