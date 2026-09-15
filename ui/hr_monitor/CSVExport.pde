ArrayList<String> sessionRows = new ArrayList<String>();
String lastExportMessage = "";
int lastExportMessageMillis = -1;

void recordSessionRow(float bpm) {
  float pct = pctOfMax(bpm);
  String zone = zoneNameFor(bpm);
  String row = millis() + "," + bpm + "," + nf(pct, 0, 1) + "," + zone + "," + modeLabel(currentMode);
  sessionRows.add(row);
}

String zoneNameFor(float bpm) {
  float pct = pctOfMax(bpm);
  if (pct < 60) return "VeryLight";
  if (pct < 70) return "Light";
  if (pct < 80) return "Moderate";
  if (pct < 90) return "Hard";
  return "Maximum";
}

void exportSession() {
  if (sessionRows.size() == 0) return;

  String[] header = {"timestamp_ms,bpm,pct_of_max,zone,mode"};
  String[] rows = sessionRows.toArray(new String[0]);

  String[] fullOutput = concat(header, rows);

  String filename = "data/" + modeLabel(currentMode).toLowerCase() + "_" + year() + nf(month(), 2) + nf(day(), 2) + "_" + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + ".csv";
  saveStrings(filename, fullOutput);

  lastExportMessage = "Saved: " + filename;
  lastExportMessageMillis = millis();

  archiveSession();
  sessionRows.clear();
}

void drawExportCue() {
  fill(TEXT_MUTED);
  textAlign(LEFT, BOTTOM);
  textSize(14);
  text("press 'e' to export session (" + sessionRows.size() + " rows)  |  'c' to compare", chartX + 24, chartY + chartH - 16);

  if (lastExportMessageMillis != -1 && millis() - lastExportMessageMillis < 4000) {
    fill(ACCENT_PRIMARY);
    textAlign(RIGHT, BOTTOM);
    text(lastExportMessage, chartX + chartW - 24, chartY + chartH - 16);
  }
}
