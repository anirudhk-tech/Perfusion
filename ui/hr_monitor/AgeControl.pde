boolean appStarted = false;
boolean editingAge = true;
String ageInputBuffer = "";

void increaseAge() {
  age++;
  maxHR = 220 - age;
}

void decreaseAge() {
  age--;
  if (age < 1) age = 1;
  maxHR = 220 - age;
}

void startAgeInput() {
  editingAge = true;
  ageInputBuffer = "";
}

boolean handleAgeInputKey() {
  if (!editingAge) {
    if (key == 'a' || key == 'A') {
      startAgeInput();
      return true;
    }
    return false;
  }

  if (key == ENTER || key == RETURN) {
    if (ageInputBuffer.length() > 0) {
      int typed = int(ageInputBuffer);
      if (typed > 0) {
        age = typed;
        maxHR = 220 - age;
        editingAge = false;
        appStarted = true;
      }
    }
    return true;
  }

  if (key == ESC) {
    if (appStarted) {
      editingAge = false;
    }
    key = 0;
    return true;
  }

  if (key == BACKSPACE) {
    if (ageInputBuffer.length() > 0) {
      ageInputBuffer = ageInputBuffer.substring(0, ageInputBuffer.length() - 1);
    }
    return true;
  }

  if (key >= '0' && key <= '9' && ageInputBuffer.length() < 3) {
    ageInputBuffer += key;
  }

  return true;
}

void drawAgeEntryScreen() {
  background(BG_TOP);

  fill(ACCENT_PRIMARY);
  textAlign(CENTER, CENTER);
  textSize(32);
  text("Enter your age", width / 2, height / 2 - 60);

  String display = ageInputBuffer.length() > 0 ? ageInputBuffer : "_";
  fill(255);
  textSize(72);
  text(display, width / 2, height / 2 + 10);

  fill(TEXT_MUTED);
  textSize(18);
  text("type a number, press Enter to continue", width / 2, height / 2 + 90);
}

void drawAgeBadge() {
  float badgeW = 260;
  float badgeH = 60;
  float badgeX = chartX + chartW - badgeW - 16;
  float badgeY = chartY + 16 + 60 + 12;

  noStroke();
  fill(CARD_BG);
  rect(badgeX, badgeY, badgeW, badgeH, CARD_RADIUS);

  if (editingAge) {
    fill(ACCENT_SECOND);
    textAlign(LEFT, CENTER);
    textSize(20);
    String display = ageInputBuffer.length() > 0 ? ageInputBuffer : "_";
    text("AGE: " + display, badgeX + 26, badgeY + 20);

    fill(TEXT_MUTED);
    textSize(13);
    text("type + Enter to confirm", badgeX + 26, badgeY + 44);
  } else {
    fill(ACCENT_PRIMARY);
    textAlign(LEFT, CENTER);
    textSize(20);
    text("AGE: " + age, badgeX + 26, badgeY + 20);

    fill(TEXT_MUTED);
    textSize(12);
    text("'a' type  ·  '[' ']' nudge", badgeX + 26, badgeY + 44);
  }
}
