int FILTER_WINDOW = 5;
float[] rawWindow = new float[FILTER_WINDOW];
int rawWindowCount = 0;

float MIN_CONFIDENCE = 0.5;

float filterReading(float rawBpm, float confidence) {
  if (confidence < MIN_CONFIDENCE) {
    println("filterReading: low confidence (" + confidence + "), holding at " + currentValue);
    return currentValue;
  }

  for (int i = 0; i < FILTER_WINDOW - 1; i++) {
    rawWindow[i] = rawWindow[i + 1];
  }
  rawWindow[FILTER_WINDOW - 1] = rawBpm;

  if (rawWindowCount < FILTER_WINDOW) rawWindowCount++;

  float sum = 0;
  int startIdx = FILTER_WINDOW - rawWindowCount;
  for (int i = startIdx; i < FILTER_WINDOW; i++) {
    sum += rawWindow[i];
  }

  float filtered = sum / rawWindowCount;
  println("filterReading: raw=" + rawBpm + " confidence=" + confidence + " -> filtered=" + filtered);
  return filtered;
}
