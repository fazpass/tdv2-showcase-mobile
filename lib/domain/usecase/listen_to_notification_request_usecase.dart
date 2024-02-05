
import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';

class ListenToNotificationRequestUseCase extends UseCase<CrossDeviceRequest, void> {
  final FazpassRepository fazpassRepo;

  ListenToNotificationRequestUseCase(this.fazpassRepo);

  @override
  Future<Stream<CrossDeviceRequest?>> buildUseCaseStream(void params) async {
    return fazpassRepo.listenToIncomingValidateNotificationRequest();
  }

}