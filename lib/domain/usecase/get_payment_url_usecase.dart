
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/home_repository.dart';

class GetPaymentUrlUseCase extends OneTimeUseCase<String, int> {
  GetPaymentUrlUseCase(HomeRepository repo) : super((params) => repo.getPaymentUrl(params!));
}