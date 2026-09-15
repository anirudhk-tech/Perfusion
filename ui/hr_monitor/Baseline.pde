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
  cardLabel("RESTING BASELINE", baselineX + 24, baselineY + 20);

  if (baselineCapturing) {
    int remainingMs = baselineDurationMs - (millis() - baselineStartMillis);
    int remainingSec = ceil(remainingMs / 1000.0);

    fill(ACCENT_SECOND);
    textAlign(LEFT, TOP);
    textSize(48);
    text(remainingSec + "s", baselineX + 20, baselineY + 45);

    textSize(16);
    fill(TEXT_MUTED);
    text("capturing...", baselineX + 24, baselineY + baselineH - 45);
  } else if (restingHR > 0) {
    fill(ACCENT_PRIMARY);
    textAlign(LEFT, TOP);
    textSize(48);
    text(nf(restingHR, 0, 1), baselineX + 20, baselineY + 45);

    textSize(18);
    fill(TEXT_MUTED);
    text("bpm resting", baselineX + 24, baselineY + baselineH - 45);
  } else {
    fill(TEXT_MUTED);
    textAlign(LEFT, TOP);
    textSize(22);
    text("Press 'b'", baselineX + 20, baselineY + 45);

    textSize(16);
    text("to capture", baselineX + 24, baselineY + baselineH - 45);
  }
}
