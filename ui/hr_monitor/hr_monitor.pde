int BUFFER_SIZE = 60;
float[] history = new float[BUFFER_SIZE];

int lastUpdate = 0;
int updateInterval = 500;
int currentValue = 100;

float minVal = 80;
float maxVal = 210;

void setup() {
  size(1500, 900);
  frameRate(60);

  for (int i = 0; i < BUFFER_SIZE; i++) {
    history[i] = currentValue;
  }

  textFont(createFont("Menlo", 64));
}

void draw() {
  computeLayout();
  drawBackground();

  drawCard(chartX, chartY, chartW, chartH);
  drawWaveform();

  drawCard(bpmX, bpmY, bpmW, bpmH);
  drawReadout();

  drawCard(baselineX, baselineY, baselineW, baselineH);
  drawBaselineUI();

  drawCard(zoneX, zoneY, zoneW, zoneH);
  drawTimeInZone();

  if (millis() - lastUpdate > updateInterval) {
    updateData();
    updateBaselineCapture(currentValue);
    updateTimeInZone(currentValue);
    lastUpdate = millis();
  }
}

void keyPressed() {
  if (key == 'b' || key == 'B') {
    startBaselineCapture();
  }
}

void updateData() {
  currentValue = int(random(90, 201));

  for (int i = 0; i < BUFFER_SIZE - 1; i++) {
    history[i] = history[i + 1];
  }
  history[BUFFER_SIZE - 1] = currentValue;
}

void drawBackground() {
  for (int y = 0; y < height; y++) {
    float t = map(y, 0, height, 0, 1);
    stroke(lerpColor(BG_TOP, BG_BOTTOM, t));
    line(0, y, width, y);
  }
}

void drawWaveform() {
  noFill();

  for (int glow = 3; glow >= 1; glow--) {
    stroke(red(ACCENT_PRIMARY), green(ACCENT_PRIMARY), blue(ACCENT_PRIMARY), 40);
    strokeWeight(glow * 4);
    drawLine();
  }

  stroke(ACCENT_PRIMARY);
  strokeWeight(2.5);
  drawLine();

  drawPoints();
}

void drawLine() {
  for (int i = 0; i < BUFFER_SIZE - 1; i++) {
    float x1 = chartXAt(i);
    float y1 = mapY(history[i]);
    float x2 = chartXAt(i + 1);
    float y2 = mapY(history[i + 1]);
    line(x1, y1, x2, y2);
  }
}

void drawPoints() {
  noStroke();
  for (int i = 0; i < BUFFER_SIZE; i++) {
    float x = chartXAt(i);
    float y = mapY(history[i]);
    fill(zoneColorFor(history[i]));
    circle(x, y, 8);
  }
}

float chartXAt(int i) {
  return map(i, 0, BUFFER_SIZE - 1, chartX + 30, chartX + chartW - 30);
}

float mapY(float val) {
  return map(val, minVal, maxVal, chartY + chartH - 40, chartY + 40);
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
