
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';

class FazpassInitializeUseCase extends OneTimeUseCase<void, List> {
  FazpassInitializeUseCase(FazpassRepository repo)
      : super((params) => repo.initialize(params!));
}