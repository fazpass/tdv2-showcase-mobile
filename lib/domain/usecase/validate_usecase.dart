
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/home_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/stored_data_repository.dart';
import 'package:tdv2_showcase_mobile/exception.dart';

class ValidateUseCase extends OneTimeUseCase<ValidateUseCaseResponse, void> {
  ValidateUseCase(HomeRepository homeRepo, FazpassRepository fazpassRepo, StoredDataRepository storedDataRepo)
      : super((params) async {
        final login = await storedDataRepo.getCurrentLoginDetail();
        if (login == null) throw NotLoggedInException();
        final meta = await fazpassRepo.generateMeta(accountIndex: login.accountIndex);
        return homeRepo.validate(login, meta);
      });
}

class ValidateUseCaseResponse {
  ValidateUseCaseResponse(this.score, this.riskDescription);

  double score;
  String riskDescription;
}