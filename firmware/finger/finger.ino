#include <Wire.h>
#include "SparkFun_Bio_Sensor_Hub_Library.h"

const int RESET_PIN = 4;
const int MFIO_PIN   = 5;
const int BUZZER_PIN = 12;

const unsigned long SAMPLE_INTERVAL_MS   = 250;
const unsigned long PRINT_HEADER_EVERY   = 20;

SparkFun_Bio_Sensor_Hub bioHub(RESET_PIN, MFIO_PIN);
bioData body;

unsigned long lastSampleTime = 0;
unsigned long lineCount = 0;

unsigned long beatInterval_ms = 0;

const unsigned long BEEP_ON_MS  = 150;
const unsigned long BEEP_OFF_MS = 120;
int beepStage = 0;
unsigned long beepStageStart = 0;

void setup() {
  Serial.begin(115200);
  while (!Serial) { ; }

  pinMode(BUZZER_PIN, OUTPUT);
  digitalWrite(BUZZER_PIN, LOW);

  Wire.begin();

  int result = bioHub.begin();
  if (result == 0) {
    Serial.println("Sensor started successfully!");
  } else {
    Serial.println("Could not communicate with the sensor. Check wiring.");
  }

  Serial.println("Configuring sensor...");
  int error = bioHub.configBpm(MODE_ONE);
  if (error == 0) {
    Serial.println("Sensor configured.");
  } else {
    Serial.print("Configuration error, code: ");
    Serial.println(error);
  }

  Serial.println("Loading up the buffer with data....");
  delay(4000);

  Serial.println("Testing buzzer...");
  digitalWrite(BUZZER_PIN, HIGH);
  delay(300);
  digitalWrite(BUZZER_PIN, LOW);

  printHeader();
}

void loop() {
  unsigned long now = millis();

  if (Serial.available() > 0) {
    char cmd = Serial.read();
    if (cmd == 'S' && beepStage == 0) {
      beepStage = 1;
      beepStageStart = now;
      digitalWrite(BUZZER_PIN, HIGH);
    }
  }

  updateBeep(now);

  if (now - lastSampleTime >= SAMPLE_INTERVAL_MS) {
    lastSampleTime = now;
    body = bioHub.readBpm();

    float hr = body.heartRate;
    float spo2 = body.oxygen;
    int confidence = body.confidence;

    bool validReading = (hr > 30 && hr < 220 && confidence > 0);

    if (validReading) {
      beatInterval_ms = (unsigned long)(60000.0 / hr);
    }

    if (lineCount % PRINT_HEADER_EVERY == 0 && lineCount != 0) {
      printHeader();
    }
    printRow(now, hr, spo2, confidence, beatInterval_ms, validReading);
    lineCount++;
  }
}

void updateBeep(unsigned long now) {
  if (beepStage == 1 && now - beepStageStart >= BEEP_ON_MS) {
    digitalWrite(BUZZER_PIN, LOW);
    beepStage = 2;
    beepStageStart = now;
  } else if (beepStage == 2 && now - beepStageStart >= BEEP_OFF_MS) {
    digitalWrite(BUZZER_PIN, HIGH);
    beepStage = 3;
    beepStageStart = now;
  } else if (beepStage == 3 && now - beepStageStart >= BEEP_ON_MS) {
    digitalWrite(BUZZER_PIN, LOW);
    beepStage = 0;
  }
}

void printHeader() {
  Serial.println();
  Serial.println("time_ms,HR_bpm,BeatInterval_ms,SpO2_pct,Confidence_pct");
}

void printRow(unsigned long t, float hr, float spo2, int confidence,
              unsigned long interval, bool valid) {
  Serial.print(t); Serial.print(",");
  Serial.print(valid ? String(hr, 1) : "NA"); Serial.print(",");
  Serial.print(valid ? String(interval) : "NA"); Serial.print(",");
  Serial.print(spo2, 1); Serial.print(",");
  Serial.println(confidence);
}
