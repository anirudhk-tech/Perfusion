float STRESS_THRESHOLD_PCT = 1.15;
int STRESS_SUSTAIN_MS = 10000;

boolean isStressed = false;
int aboveThresholdSinceMillis = -1;

void updateStressDetection(float bpm) {
  if (restingHR <= 0) {
    isStressed = false;
    aboveThresholdSinceMillis = -1;
    return;
  }

  float threshold = restingHR * STRESS_THRESHOLD_PCT;

  if (bpm >= threshold) {
    if (aboveThresholdSinceMillis == -1) {
      aboveThresholdSinceMillis = millis();
    }
    if (millis() - aboveThresholdSinceMillis >= STRESS_SUSTAIN_MS) {
      isStressed = true;
    }
  } else {
    aboveThresholdSinceMillis = -1;
    isStressed = false;
  }
}

void drawStressIndicator() {
  cardLabel("STRESS STATE", stressX + 24, stressY + 20);

  color dotColor = isStressed ? ZONE_MAX : ZONE_LIGHT;
  fill(dotColor);
  noStroke();
  circle(stressX + 32, stressY + 55, 14);

  fill(255);
  textAlign(LEFT, CENTER);
  textSize(22);
  text(isStressed ? "STRESSED" : "NORMAL", stressX + 52, stressY + 53);

  fill(TEXT_MUTED);
  textSize(13);
  if (restingHR <= 0) {
    text("needs baseline", stressX + 24, stressY + stressH - 20);
  } else {
    text(">=15% resting, 10s", stressX + 24, stressY + stressH - 20);
  }
}
