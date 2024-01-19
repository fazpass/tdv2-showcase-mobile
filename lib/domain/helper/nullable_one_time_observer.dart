import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class NullableOneTimeObserver<T> implements Observer<T> {
  const NullableOneTimeObserver(this.onNextCallback, this.onErrorCallback);

  final Function(T?) onNextCallback;
  final Function(dynamic) onErrorCallback;

  @override
  void onComplete() {}

  @override
  void onError(e) {
    onErrorCallback(e);
  }

  @override
  void onNext(T? response) {
    onNextCallback(response);
  }
}