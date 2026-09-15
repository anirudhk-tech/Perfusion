int BUFFER_SIZE = 60;
float[] history = new float[BUFFER_SIZE];

int lastUpdate = 0;
int updateInterval = 500;
int currentValue = 240;

float minVal = 180;
float maxVal = 320;

void setup() {
  size(1500, 1000);
  frameRate(60);

  for (int i = 0; i < BUFFER_SIZE; i++) {
    history[i] = currentValue;
  }

  textFont(createFont("Menlo", 64));
}

void draw() {
  drawBackground();

  drawWaveform();
  drawReadout();
  drawBaselineUI();

  if (millis() - lastUpdate > updateInterval) {
    updateData();
    updateBaselineCapture(currentValue);
    lastUpdate = millis();
  }
}

void keyPressed() {
  if (key == 'b' || key == 'B') {
    startBaselineCapture();
  }
}

void updateData() {
  currentValue = int(random(250, 301));

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
    strokeWeight(glow * 4);
    drawSegments(40);
  }

  strokeWeight(2.5);
  drawSegments(255);
}

void drawSegments(int alpha) {
  for (int i = 0; i < BUFFER_SIZE - 1; i++) {
    float x1 = map(i, 0, BUFFER_SIZE - 1, 0, width);
    float y1 = mapY(history[i]);
    float x2 = map(i + 1, 0, BUFFER_SIZE - 1, 0, width);
    float y2 = mapY(history[i + 1]);

    color segColor = zoneColorFor(history[i + 1]);
    stroke(red(segColor), green(segColor), blue(segColor), alpha);
    line(x1, y1, x2, y2);
  }
}

float mapY(float val) {
  return map(val, minVal, maxVal, height - 40, 40);
}

void drawReadout() {
  noStroke();
  fill(PANEL_COLOR);
  rect(0, 0, 260, 130);

  fill(ACCENT_PRIMARY);
  textAlign(LEFT, TOP);
  textSize(64);
  text(currentValue, 30, 20);

  textSize(18);
  fill(TEXT_MUTED);
  text("BPM", 32, 95);
}
