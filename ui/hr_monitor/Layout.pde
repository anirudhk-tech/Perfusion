float MARGIN = 24;
float GAP = 20;

float chartX, chartY, chartW, chartH;
float bpmX, bpmY, bpmW, bpmH;
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

  bpmX = MARGIN;
  bpmY = rowY;
  bpmH = rowH;

  float splitH = (rowH - GAP) / 2;

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
