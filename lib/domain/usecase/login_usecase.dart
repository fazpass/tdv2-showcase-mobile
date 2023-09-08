
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/login_repository.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';

class LoginUseCase extends OneTimeUseCase<LoginUseCaseResponse, String> {

  LoginUseCase(LoginRepository loginRepo, FazpassRepository fazpassRepo)
      : super((phoneNumber) async {
    final meta = await fazpassRepo.generateMeta();
    print(meta);

    final canLoginInstantly = await loginRepo.login(phoneNumber!, meta);
    if (canLoginInstantly) return LoginUseCaseResponse(true);

    final otpId = await loginRepo.requestOtp(phoneNumber);
    return LoginUseCaseResponse(false, otpId: otpId, meta: meta);
      });
}

class LoginUseCaseResponse {
  final bool canLoginInstantly;
  final String? otpId;
  final String? meta;

  LoginUseCaseResponse(this.canLoginInstantly, {this.otpId, this.meta});
}