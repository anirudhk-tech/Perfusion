import processing.serial.*;

String SERIAL_PORT_NAME = "/dev/cu.usbmodem123456781";
int SERIAL_BAUD = 115200;

Serial arduinoPort;

float pendingHr = -1;
float pendingConfidencePct = -1;
float pendingOxygen = -1;
int pendingStatus = -1;

void setupSerial() {
  println("Available serial ports:");
  printArray(Serial.list());

  arduinoPort = new Serial(this, SERIAL_PORT_NAME, SERIAL_BAUD);
  arduinoPort.bufferUntil('\n');
}

void serialEvent(Serial p) {
  String line = p.readStringUntil('\n');
  if (line == null) return;
  line = trim(line);
  if (line.length() == 0) return;

  if (line.startsWith("Heartrate:")) {
    pendingHr = float(trim(line.substring(line.indexOf(':') + 1)));
    return;
  }

  if (line.startsWith("Confidence:")) {
    pendingConfidencePct = float(trim(line.substring(line.indexOf(':') + 1)));
    return;
  }

  if (line.startsWith("Oxygen:")) {
    pendingOxygen = float(trim(line.substring(line.indexOf(':') + 1)));
    return;
  }

  if (line.startsWith("Status:")) {
    pendingStatus = int(trim(line.substring(line.indexOf(':') + 1)));
    processSensorCycle();
    return;
  }

  println("serialEvent: unrecognized line: " + line);
}

void processSensorCycle() {
  if (Float.isNaN(pendingHr) || Float.isNaN(pendingConfidencePct) || Float.isNaN(pendingOxygen)) {
    println("processSensorCycle: skipped (NaN parse)");
    resetPendingCycle();
    return;
  }

  if (pendingStatus < 2) {
    println("processSensorCycle: skipped (status=" + pendingStatus + ", no finger / weak signal)");
    resetPendingCycle();
    return;
  }

  currentSpo2 = pendingOxygen;
  currentConfidencePct = pendingConfidencePct;

  float confidence = pendingConfidencePct / 100.0;
  println("hr=" + pendingHr + " confidencePct=" + pendingConfidencePct + " spo2=" + pendingOxygen + " status=" + pendingStatus);
  onNewReading(filterReading(pendingHr, confidence));

  resetPendingCycle();
}

void resetPendingCycle() {
  pendingHr = -1;
  pendingConfidencePct = -1;
  pendingOxygen = -1;
  pendingStatus = -1;
}
