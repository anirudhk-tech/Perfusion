import processing.serial.*;

String SERIAL_PORT_NAME = "COM7";
int SERIAL_BAUD = 115200;

Serial arduinoPort;

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

  String[] fields = split(line, ',');
  if (fields.length != 5) return;

  String hrField = fields[1];
  if (hrField.equals("NA")) return;

  float hr = float(hrField);
  float confidencePct = float(fields[4]);

  if (Float.isNaN(hr) || Float.isNaN(confidencePct)) return;

  float confidence = confidencePct / 100.0;
  println("hr=" + hr + " confidencePct=" + confidencePct);
  onNewReading(filterReading(hr, confidence));
}
