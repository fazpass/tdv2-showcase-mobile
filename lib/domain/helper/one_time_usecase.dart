
import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class OneTimeUseCase<Response, Params> extends UseCase<Response, Params> {
  OneTimeUseCase(this.function);

  final Future<Response> Function(Params?) function;

  @override
  Future<Stream<Response?>> buildUseCaseStream(Params? params) async {
    final StreamController<Response> controller = StreamController();
    try {
      final result = await function(params);
      controller.add(result);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}