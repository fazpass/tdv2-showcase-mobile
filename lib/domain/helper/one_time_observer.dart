import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class OneTimeObserver<T> implements Observer<T> {
  const OneTimeObserver(this.onNextCallback, this.onErrorCallback);

  final Function(T) onNextCallback;
  final Function(dynamic) onErrorCallback;

  @override
  void onComplete() {}

  @override
  void onError(e) {
    onErrorCallback(e);
  }

  @override
  void onNext(T? response) {
    if (response != null) onNextCallback(response);
  }
}