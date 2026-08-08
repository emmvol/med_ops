class CaseTimerOptions {

  static const Duration defaultDuration =
  Duration(hours: 1);

  static const Duration minimumDuration =
  Duration(hours: 1);

  static const Duration maximumDuration =
  Duration(hours: 4);

  static const Duration step =
  Duration(minutes: 15);

  static List<Duration> get options {

    final List<Duration> values = [];

    for (
    Duration duration = minimumDuration;
    duration <= maximumDuration;
    duration += step
    ) {
      values.add(duration);
    }

    return values;
  }

}