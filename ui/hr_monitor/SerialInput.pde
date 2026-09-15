import processing.serial.*;

String SERIAL_PORT_NAME = "COM7";
int SERIAL_BAUD = 115200;

Serial arduinoPort;

void setupSerial() {
  println("Available serial ports:");
  printArray(Serial.list());

  arduinoPort = new Serial(this, SERIAL_PORT_NAME, SERIAL_BAUD);
}

void pollSerial() {
  while (arduinoPort.available() > 0) {
    String line = arduinoPort.readStringUntil('\n');
    if (line == null) break;
    processSerialLine(line);
  }
}

void processSerialLine(String rawLine) {
  String line = trim(rawLine);
  if (line.length() == 0) return;

  String[] fields = split(line, ',');
  if (fields.length != 5) {
    println("skipped line (fields=" + fields.length + "): " + line);
    return;
  }

  String hrField = fields[1];
  if (hrField.equals("NA")) return;

  float hr = float(hrField);
  float confidencePct = float(fields[4]);

  if (Float.isNaN(hr) || Float.isNaN(confidencePct)) {
    println("skipped line (NaN): " + line);
    return;
  }

  float confidence = confidencePct / 100.0;
  println("hr=" + hr + " confidencePct=" + confidencePct);
  onNewReading(filterReading(hr, confidence));
}
