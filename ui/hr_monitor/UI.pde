color CARD_BG = color(255, 255, 255, 18);
float CARD_RADIUS = 28;

void drawCard(float x, float y, float w, float h) {
  noStroke();
  fill(CARD_BG);
  rect(x, y, w, h, CARD_RADIUS);
}

void cardLabel(String label, float x, float y) {
  fill(TEXT_MUTED);
  textAlign(LEFT, TOP);
  textSize(14);
  text(label, x, y);
}
