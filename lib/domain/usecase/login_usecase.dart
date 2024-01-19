
import 'package:newrelic_mobile/newrelic_mobile.dart';
import 'package:tdv2_showcase_mobile/domain/entity/notifiable_device.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/login_repository.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/stored_data_repository.dart';

class LoginUseCase extends OneTimeUseCase<LoginUseCaseResponse, String> {
  LoginUseCase(LoginRepository loginRepo, FazpassRepository fazpassRepo, StoredDataRepository storedDataRepo)
      : super((phoneNumber) async {
        final meta = await fazpassRepo.generateMeta();
        await NewrelicMobile.instance.recordCustomEvent(
          'FazpassEvent',
          eventName: 'Generate Meta',
          eventAttributes: {
            'meta': meta,
          },
        );

        final response = await loginRepo.login(phoneNumber!, meta);
        if (response.canLoginInstantly) storedDataRepo.saveLoginDetail(phoneNumber, response.fazpassId!);
        return response;
      });
}

class LoginUseCaseResponse {
  final bool canLoginInstantly;
  final String meta;
  final List<NotifiableDevice> notifiableDevices;
  final String challenge;
  final String? fazpassId;

  LoginUseCaseResponse(this.canLoginInstantly, this.meta, this.notifiableDevices, this.challenge, {this.fazpassId});
}