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
  computeLayout();
  drawBackground();

  drawCard(chartX, chartY, chartW, chartH);
  drawWaveform();
  drawModeBadge();
  drawExportCue();

  drawCard(bpmX, bpmY, bpmW, bpmH);
  drawReadout();

  drawCard(baselineX, baselineY, baselineW, baselineH);
  drawBaselineUI();

  drawCard(stressX, stressY, stressW, stressH);
  drawStressIndicator();

  drawCard(zoneX, zoneY, zoneW, zoneH);
  drawTimeInZone();

  drawCompareOverlay();

  if (USE_SERIAL) {
    pollSerial();
  } else {
    updateMockData();
  }
}

void keyPressed() {
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
}

void drawReadout() {
  cardLabel("CURRENT", bpmX + 24, bpmY + 20);

  fill(ACCENT_PRIMARY);
  textAlign(LEFT, TOP);
  textSize(72);
  text(currentValue, bpmX + 20, bpmY + 45);

  textSize(20);
  fill(TEXT_MUTED);
  text("BPM", bpmX + 24, bpmY + bpmH - 45);
}
