boolean baselineCapturing = false;
int baselineStartMillis = 0;
int baselineDurationMs = 30000;

float baselineSum = 0;
int baselineSamples = 0;

float restingHR = -1;

void startBaselineCapture() {
  baselineCapturing = true;
  baselineStartMillis = millis();
  baselineSum = 0;
  baselineSamples = 0;
}

void updateBaselineCapture(float latestBpm) {
  if (!baselineCapturing) return;

  baselineSum += latestBpm;
  baselineSamples++;

  if (millis() - baselineStartMillis >= baselineDurationMs) {
    restingHR = baselineSum / baselineSamples;
    baselineCapturing = false;
  }
}

void drawBaselineUI() {
  if (baselineCapturing) {
    int remainingMs = baselineDurationMs - (millis() - baselineStartMillis);
    int remainingSec = ceil(remainingMs / 1000.0);

    noStroke();
    fill(PANEL_COLOR);
    rect(width - 260, 0, 260, 90);

    fill(ACCENT_SECOND);
    textAlign(LEFT, TOP);
    textSize(20);
    text("CAPTURING BASELINE", width - 240, 15);

    textSize(40);
    text(remainingSec + "s", width - 240, 40);
  } else if (restingHR > 0) {
    noStroke();
    fill(PANEL_COLOR);
    rect(width - 260, 0, 260, 70);

    fill(ACCENT_PRIMARY);
    textAlign(LEFT, TOP);
    textSize(18);
    text("RESTING HR", width - 240, 15);
    textSize(28);
    text(nf(restingHR, 0, 1) + " bpm", width - 240, 38);
  } else {
    noStroke();
    fill(PANEL_COLOR);
    rect(width - 260, 0, 260, 50);

    fill(TEXT_MUTED);
    textAlign(LEFT, TOP);
    textSize(16);
    text("Press 'b' to capture", width - 240, 18);
  }
}
