
import 'package:tdv2_showcase_mobile/domain/entity/promo.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/home_repository.dart';

class GetPromosUseCase extends OneTimeUseCase<List<Promo>, void> {
  GetPromosUseCase(HomeRepository repo) : super((param) => repo.getPromos());
}