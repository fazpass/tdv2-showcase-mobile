
import 'package:newrelic_mobile/newrelic_mobile.dart';
import 'package:tdv2_showcase_mobile/domain/entity/notifiable_device.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/login_repository.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';

class LoginUseCase extends OneTimeUseCase<LoginUseCaseResponse, String> {

  LoginUseCase(LoginRepository loginRepo, FazpassRepository fazpassRepo)
      : super((phoneNumber) async {
    final meta = await fazpassRepo.generateMeta();
    await NewrelicMobile.instance.recordCustomEvent(
      'FazpassEvent',
      eventName: 'Generate Meta',
      eventAttributes: {
        'meta': meta,
      },
    );

    return loginRepo.login(phoneNumber!, meta);
      });
}

class LoginUseCaseResponse {
  final bool canLoginInstantly;
  final String meta;
  final List<NotifiableDevice> notifiableDevices;

  LoginUseCaseResponse(this.canLoginInstantly, this.meta, this.notifiableDevices);
}