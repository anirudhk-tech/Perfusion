/*
  BME/CS 479 - Lab 1: Photoplethysmography (PPG) Fitness Wristband
  Spring 2026

  Hardware:
    - FireBeetle 328P (BLE4.1)
    - SparkFun Pulse Oximeter and Heart Rate Monitor (MAX30101 + MAX32664)

  Wiring (per lab handout):
    FireBeetle 3v3  -> Sensor 3V3
    FireBeetle GND  -> Sensor GND
    FireBeetle SDA  -> Sensor SDA
    FireBeetle SCL  -> Sensor SCL
    FireBeetle D4   -> Sensor RST
    FireBeetle D5   -> Sensor MFIO

  Library required:
    SparkFun Bio Sensor Hub Library (MAX3010x)
    Install via Arduino Library Manager: "SparkFun Bio Sensor Hub Library"

  What this sketch does:
    Streams the following over Serial as CSV, once per sample:
      - time_ms          : milliseconds since the board started
      - HR_bpm           : heart rate in beats per minute
      - BeatInterval_ms  : time between beats
      - SpO2_pct         : blood oxygen saturation
      - Confidence_pct   : confidence in the SpO2 reading
      - RestingHR_bpm    : 30-second resting heart rate baseline
                           ("pending" until the first 30 seconds elapse)
*/

#include <Wire.h>
#include "SparkFun_Bio_Sensor_Hub_Library.h"

// ---------- Pin definitions ----------
const int RESET_PIN = 4;   // D4
const int MFIO_PIN   = 5;  // D5
const int BUZZER_PIN = 12; // D12

// ---------- Timing ----------
const unsigned long SAMPLE_INTERVAL_MS   = 250;   // how often we poll the sensor
const unsigned long RESTING_BASELINE_MS  = 30000; // 30-second resting HR baseline
const unsigned long PRINT_HEADER_EVERY   = 20;    // reprint CSV header every N lines

// ---------- Globals ----------
SparkFun_Bio_Sensor_Hub bioHub(RESET_PIN, MFIO_PIN);
bioData body;

unsigned long lastSampleTime = 0;
unsigned long lineCount = 0;

// Resting baseline
bool baselineComplete = false;
unsigned long baselineStartTime = 0;
float baselineSum = 0;
unsigned int baselineSamples = 0;
float restingHR = 0;

// Beat-to-beat interval tracking
unsigned long beatInterval_ms = 0;

// ---------------------------------------------------------
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
  int error = bioHub.configBpm(MODE_ONE); // BPM + SpO2 mode
  if (error == 0) {
    Serial.println("Sensor configured.");
  } else {
    Serial.print("Configuration error, code: ");
    Serial.println(error);
  }

  Serial.println("Loading up the buffer with data....");
  delay(4000);

  // Startup test beep - confirms the buzzer is wired and working correctly
  Serial.println("Testing buzzer...");
  digitalWrite(BUZZER_PIN, HIGH);
  delay(300);
  digitalWrite(BUZZER_PIN, LOW);

  baselineStartTime = millis();

  printHeader();
}

// ---------------------------------------------------------
void loop() {
  unsigned long now = millis();

  if (now - lastSampleTime >= SAMPLE_INTERVAL_MS) {
    lastSampleTime = now;
    body = bioHub.readBpm();

    float hr = body.heartRate;        // beats per minute
    float spo2 = body.oxygen;         // %
    int confidence = body.confidence; // 0-100

    // Only treat data as valid if the sensor reports a plausible heart rate
    bool validReading = (hr > 30 && hr < 220 && confidence > 0);

    // ---- Beat-to-beat interval ----
    // The MAX32664 gives filtered HR, not raw beat timestamps directly, so we
    // derive an approximate R-R style interval from the current BPM value.
    if (validReading) {
      beatInterval_ms = (unsigned long)(60000.0 / hr);
    }

    // ---- Resting heart rate baseline (first 30 s) ----
    if (!baselineComplete) {
      if (validReading) {
        baselineSum += hr;
        baselineSamples++;
      }
      if (now - baselineStartTime >= RESTING_BASELINE_MS) {
        if (baselineSamples > 0) {
          restingHR = baselineSum / baselineSamples;
        }
        baselineComplete = true;
        Serial.print("### Resting HR baseline established: ");
        Serial.print(restingHR, 1);
        Serial.println(" bpm ###");
      }
    }

    // ---- Print CSV row ----
    if (lineCount % PRINT_HEADER_EVERY == 0 && lineCount != 0) {
      printHeader();
    }
    printRow(now, hr, spo2, confidence, beatInterval_ms, validReading);
    lineCount++;
  }
}

// ---------------------------------------------------------
void printHeader() {
  Serial.println();
  Serial.println("time_ms,HR_bpm,BeatInterval_ms,SpO2_pct,Confidence_pct,RestingHR_bpm");
}

void printRow(unsigned long t, float hr, float spo2, int confidence,
              unsigned long interval, bool valid) {
  Serial.print(t); Serial.print(",");
  Serial.print(valid ? String(hr, 1) : "NA"); Serial.print(",");
  Serial.print(valid ? String(interval) : "NA"); Serial.print(",");
  Serial.print(spo2, 1); Serial.print(",");
  Serial.print(confidence); Serial.print(",");
  Serial.println(baselineComplete ? String(restingHR, 1) : "pending");
}
