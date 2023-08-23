import 'package:tdv2_showcase_mobile/domain/entity/validate_result.dart';
import 'package:tdv2_showcase_mobile/domain/repo/home_repository.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';

class ValidateUseCase extends OneTimeUseCase<ValidateResult, String> {
  ValidateUseCase(HomeRepository repo)
      : super((params) => repo.validate(params!));
}