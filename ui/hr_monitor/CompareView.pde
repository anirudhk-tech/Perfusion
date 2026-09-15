int MAX_ARCHIVED_SESSIONS = 2;
ArrayList<float[]> archivedBpm = new ArrayList<float[]>();
ArrayList<String> archivedModeLabel = new ArrayList<String>();
ArrayList<Float> archivedAvgBpm = new ArrayList<Float>();
ArrayList<Float> archivedMaxBpm = new ArrayList<Float>();
ArrayList<Integer> archivedActiveSec = new ArrayList<Integer>();
ArrayList<String> archivedDominantZone = new ArrayList<String>();

boolean showCompare = false;

void archiveSession() {
  int n = sessionRows.size();
  if (n == 0) return;

  float[] bpmSeries = new float[n];
  float sum = 0;
  float maxB = 0;
  int[] zoneCounts = new int[5];

  for (int i = 0; i < n; i++) {
    String[] parts = split(sessionRows.get(i), ',');
    float bpm = float(parts[1]);
    bpmSeries[i] = bpm;
    sum += bpm;
    if (bpm > maxB) maxB = bpm;

    String zone = parts[3];
    if (zone.equals("VeryLight")) zoneCounts[0]++;
    else if (zone.equals("Light")) zoneCounts[1]++;
    else if (zone.equals("Moderate")) zoneCounts[2]++;
    else if (zone.equals("Hard")) zoneCounts[3]++;
    else zoneCounts[4]++;
  }

  String[] zoneNames = {"Very Light", "Light", "Moderate", "Hard", "Maximum"};
  int dominantIdx = 0;
  for (int i = 1; i < 5; i++) {
    if (zoneCounts[i] > zoneCounts[dominantIdx]) dominantIdx = i;
  }

  archivedBpm.add(bpmSeries);
  archivedModeLabel.add(modeLabel(currentMode));
  archivedAvgBpm.add(sum / n);
  archivedMaxBpm.add(maxB);
  archivedActiveSec.add(n * (updateInterval / 1000));
  archivedDominantZone.add(zoneNames[dominantIdx]);

  if (archivedBpm.size() > MAX_ARCHIVED_SESSIONS) {
    archivedBpm.remove(0);
    archivedModeLabel.remove(0);
    archivedAvgBpm.remove(0);
    archivedMaxBpm.remove(0);
    archivedActiveSec.remove(0);
    archivedDominantZone.remove(0);
  }
}

void toggleCompare() {
  showCompare = !showCompare;
}

void drawCompareOverlay() {
  if (!showCompare) return;

  noStroke();
  fill(0, 0, 0, 190);
  rect(0, 0, width, height);

  fill(255);
  textAlign(CENTER, TOP);
  textSize(28);
  text("SESSION COMPARISON", width / 2, MARGIN);

  fill(TEXT_MUTED);
  textSize(14);
  text("press 'c' to close", width / 2, MARGIN + 36);

  if (archivedBpm.size() < 2) {
    fill(TEXT_MUTED);
    textSize(18);
    text("Export at least 2 sessions ('e') to compare", width / 2, height / 2);
    return;
  }

  float panelW = (width - MARGIN * 3) / 2;
  float panelH = height - MARGIN * 3 - 80;
  float panelY = MARGIN * 2 + 60;

  drawSessionPanel(MARGIN, panelY, panelW, panelH, 0);
  drawSessionPanel(MARGIN * 2 + panelW, panelY, panelW, panelH, 1);
}

void drawSessionPanel(float x, float y, float w, float h, int idx) {
  fill(CARD_BG);
  noStroke();
  rect(x, y, w, h, CARD_RADIUS);

  fill(ACCENT_PRIMARY);
  textAlign(LEFT, TOP);
  textSize(22);
  text(archivedModeLabel.get(idx), x + 24, y + 20);

  float[] bpmSeries = archivedBpm.get(idx);
  float sparkX = x + 24;
  float sparkY = y + 70;
  float sparkW = w - 48;
  float sparkH = h * 0.35;

  float lo = 60, hi = 200;
  noFill();
  stroke(ACCENT_SECOND);
  strokeWeight(2);
  beginShape();
  for (int i = 0; i < bpmSeries.length; i++) {
    float px = map(i, 0, bpmSeries.length - 1, sparkX, sparkX + sparkW);
    float py = map(bpmSeries[i], lo, hi, sparkY + sparkH, sparkY);
    vertex(px, py);
  }
  endShape();

  float statsY = sparkY + sparkH + 30;
  fill(TEXT_MUTED);
  textSize(14);
  textAlign(LEFT, TOP);
  text("AVG BPM", x + 24, statsY);
  text("MAX BPM", x + 24, statsY + 60);
  text("ACTIVE TIME", x + 24, statsY + 120);
  text("DOMINANT ZONE", x + 24, statsY + 180);

  fill(255);
  textSize(24);
  text(nf(archivedAvgBpm.get(idx), 0, 1), x + 24, statsY + 18);
  text(nf(archivedMaxBpm.get(idx), 0, 0), x + 24, statsY + 78);
  text(archivedActiveSec.get(idx) + "s", x + 24, statsY + 138);
  text(archivedDominantZone.get(idx), x + 24, statsY + 198);
}
