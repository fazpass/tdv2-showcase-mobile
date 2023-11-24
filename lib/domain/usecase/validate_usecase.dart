import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/home_repository.dart';

class ValidateUseCase extends OneTimeUseCase<ValidateUseCaseResponse, void> {
  ValidateUseCase(HomeRepository homeRepo, FazpassRepository fazpassRepo)
      : super((params) async {
        final meta = await fazpassRepo.generateMeta();
        return homeRepo.validate(meta);
      });
}

class ValidateUseCaseResponse {
  ValidateUseCaseResponse(this.score, this.riskDescription);

  int score;
  String riskDescription;
}