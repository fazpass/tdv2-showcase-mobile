

class RequestLog {
  final String name;
  late final bool status;
  late final String parameters;
  late final String response;
  late final int startTime;
  late final int endTime;

  RequestLog(this.name);

  void start(String parameters) {
    startTime = DateTime.timestamp().millisecondsSinceEpoch;
    this.parameters = parameters;
  }

  void stop(bool status, String response) {
    endTime  = DateTime.timestamp().millisecondsSinceEpoch;
    this.status = status;
    this.response = response;
  }

  int get duration => endTime - startTime;

  String get readableDuration {
    final time = DateTime.fromMillisecondsSinceEpoch(duration);
    return '${time.second} second ${time.millisecond} millisecond';
  }
}