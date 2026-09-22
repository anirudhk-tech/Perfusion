void increaseAge() {
  age++;
  maxHR = 220 - age;
}

void decreaseAge() {
  age--;
  if (age < 1) age = 1;
  maxHR = 220 - age;
}

void drawAgeBadge() {
  float badgeW = 220;
  float badgeH = 60;
  float badgeX = chartX + chartW - badgeW - 16;
  float badgeY = chartY + 16 + 60 + 12;

  noStroke();
  fill(CARD_BG);
  rect(badgeX, badgeY, badgeW, badgeH, CARD_RADIUS);

  fill(ACCENT_PRIMARY);
  textAlign(LEFT, CENTER);
  textSize(20);
  text("AGE: " + age, badgeX + 26, badgeY + 20);

  fill(TEXT_MUTED);
  textSize(13);
  text("'[' / ']' to adjust", badgeX + 26, badgeY + 44);
}
