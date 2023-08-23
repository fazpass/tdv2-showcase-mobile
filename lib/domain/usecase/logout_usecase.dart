import 'package:tdv2_showcase_mobile/domain/repo/home_repository.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';

class LogoutUseCase extends OneTimeUseCase<bool, String> {
  LogoutUseCase(HomeRepository repo)
      : super((params) => repo.logout(params!));
}
