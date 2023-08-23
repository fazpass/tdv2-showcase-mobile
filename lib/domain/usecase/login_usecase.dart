import 'package:tdv2_showcase_mobile/domain/repo/login_repository.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';

class LoginUseCase extends OneTimeUseCase<String, LoginUseCaseParam> {
  LoginUseCase(LoginRepository repo)
      : super((params) => repo.login(params!.phoneNumber, params.meta));
}

class LoginUseCaseParam {
  LoginUseCaseParam(this.phoneNumber, this.meta);

  final String phoneNumber;
  final String meta;
}