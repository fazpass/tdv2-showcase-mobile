
import 'package:tdv2_showcase_mobile/domain/entity/tenant.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/home_repository.dart';

class GetTenantsUseCase extends OneTimeUseCase<List<Tenant>, void> {
  GetTenantsUseCase(HomeRepository repo) : super((param) => repo.getTenants());
}