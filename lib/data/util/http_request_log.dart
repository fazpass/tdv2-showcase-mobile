

class RequestLog {
  final String name;
  int? startTime;
  int? endTime;
  bool? status;

  RequestLog(this.name);

  void start() {
    startTime = DateTime.timestamp().millisecondsSinceEpoch;
  }

  void stop(bool status) {
    endTime  = DateTime.timestamp().millisecondsSinceEpoch;
    this.status = status;
  }

  int get duration => (endTime ?? 0) - (startTime ?? 0);

  String get readableDuration {
    final time = DateTime.fromMillisecondsSinceEpoch(duration);
    return '${time.second} second ${time.millisecond} millisecond';
  }
}