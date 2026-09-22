float MARGIN = 24;
float GAP = 20;

float chartX, chartY, chartW, chartH;
float bpmX, bpmY, bpmW, bpmH;
float spo2X, spo2Y, spo2W, spo2H;
float baselineX, baselineY, baselineW, baselineH;
float stressX, stressY, stressW, stressH;
float zoneX, zoneY, zoneW, zoneH;

void computeLayout() {
  chartX = MARGIN;
  chartY = MARGIN;
  chartW = width - MARGIN * 2;
  chartH = height * 0.55;

  float rowY = chartY + chartH + GAP;
  float rowH = height - rowY - MARGIN;

  bpmW = 320;
  baselineW = 320;

  float splitH = (rowH - GAP) / 2;

  bpmX = MARGIN;
  bpmY = rowY;
  bpmH = splitH;

  spo2X = bpmX;
  spo2W = bpmW;
  spo2Y = bpmY + bpmH + GAP;
  spo2H = splitH;

  baselineX = bpmX + bpmW + GAP;
  baselineY = rowY;
  baselineH = splitH;

  stressX = baselineX;
  stressW = baselineW;
  stressY = baselineY + baselineH + GAP;
  stressH = splitH;

  zoneX = baselineX + baselineW + GAP;
  zoneY = rowY;
  zoneW = width - MARGIN - zoneX;
  zoneH = rowH;
}
