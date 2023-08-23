
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/login_repository.dart';

class IsLoggedInUseCase extends OneTimeUseCase<bool, void> {
  IsLoggedInUseCase(LoginRepository repo) : super((params) => repo.isLoggedIn());
}