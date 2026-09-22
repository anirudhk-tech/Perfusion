int lastUpdate = 0;
int updateInterval = 500;
int currentValue = 100;
float currentSpo2 = 98;

void updateMockData() {
  if (millis() - lastUpdate <= updateInterval) return;

  float rawBpm = random(90, 201);
  float confidence = random(0, 1);
  onNewReading(filterReading(rawBpm, confidence));
  lastUpdate = millis();
}

void onNewReading(float value) {
  currentValue = int(value);
  println("onNewReading: currentValue set to " + currentValue);
  pushToHistory(currentValue);

  updateBaselineCapture(currentValue);
  updateTimeInZone(currentValue);
  updateStressDetection(currentValue);
  recordSessionRow(currentValue);
}
