boolean USE_SERIAL = true;

void setup() {
  size(1500, 900);
  frameRate(60);

  initChartHistory(currentValue);
  textFont(createFont("Menlo", 64));

  if (USE_SERIAL) {
    setupSerial();
  }
}

void draw() {
  if (!appStarted) {
    drawAgeEntryScreen();
    return;
  }

  computeLayout();
  drawBackground();

  drawCard(chartX, chartY, chartW, chartH);
  drawWaveform();
  drawModeBadge();
  drawAgeBadge();
  drawExportCue();

  drawCard(bpmX, bpmY, bpmW, bpmH);
  drawReadout();

  drawCard(spo2X, spo2Y, spo2W, spo2H);
  drawSpo2Readout();

  drawCard(baselineX, baselineY, baselineW, baselineH);
  drawBaselineUI();

  drawCard(stressX, stressY, stressW, stressH);
  drawStressIndicator();

  drawCard(zoneX, zoneY, zoneW, zoneH);
  drawTimeInZone();

  drawCompareOverlay();

  if (!USE_SERIAL) {
    updateMockData();
  }
}

void keyPressed() {
  if (handleAgeInputKey()) return;

  if (key == 'b' || key == 'B') {
    startBaselineCapture();
  }
  if (key == 'm' || key == 'M') {
    cycleMode();
  }
  if (key == 'e' || key == 'E') {
    exportSession();
  }
  if (key == 'c' || key == 'C') {
    toggleCompare();
  }
  if (key == '[') {
    decreaseAge();
  }
  if (key == ']') {
    increaseAge();
  }
}

void drawReadout() {
  cardLabel("CURRENT", bpmX + 24, bpmY + 20);

  fill(ACCENT_PRIMARY);
  textAlign(LEFT, TOP);
  textSize(48);
  text(currentValue, bpmX + 20, bpmY + 40);

  textSize(16);
  fill(TEXT_MUTED);
  text("BPM", bpmX + 24, bpmY + bpmH - 30);

  if (currentBeatIntervalMs > 0) {
    fill(ACCENT_SECOND);
    textAlign(RIGHT, TOP);
    textSize(20);
    text(int(currentBeatIntervalMs) + " ms", bpmX + bpmW - 24, bpmY + 20);

    fill(TEXT_MUTED);
    textSize(14);
    text("beat interval", bpmX + bpmW - 24, bpmY + 44);
  }
}

void drawSpo2Readout() {
  cardLabel("BLOOD OXYGEN", spo2X + 24, spo2Y + 20);

  fill(ACCENT_SECOND);
  textAlign(LEFT, TOP);
  textSize(48);
  text(nf(currentSpo2, 0, 1), spo2X + 20, spo2Y + 40);

  textSize(16);
  fill(TEXT_MUTED);
  text("SpO2 %", spo2X + 24, spo2Y + spo2H - 30);

  String confLabel = currentConfidencePct >= 50 ? "Good" : "Low";
  color confColor = currentConfidencePct >= 50 ? ZONE_LIGHT : ZONE_MAX;

  fill(confColor);
  textAlign(RIGHT, TOP);
  textSize(20);
  text(int(currentConfidencePct) + "%", spo2X + spo2W - 24, spo2Y + 20);

  fill(TEXT_MUTED);
  textSize(14);
  text("confidence (" + confLabel + ")", spo2X + spo2W - 24, spo2Y + 44);
}
