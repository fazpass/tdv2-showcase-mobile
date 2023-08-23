
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';

class FazpassGenerateMetaUseCase extends OneTimeUseCase<String, void> {
  FazpassGenerateMetaUseCase(FazpassRepository repo)
      : super((params) => repo.generateMeta());
}