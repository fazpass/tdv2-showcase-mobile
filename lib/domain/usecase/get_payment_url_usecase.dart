
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/home_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/stored_data_repository.dart';
import 'package:tdv2_showcase_mobile/exception.dart';

class GetPaymentUrlUseCase extends OneTimeUseCase<String, int> {
  GetPaymentUrlUseCase(HomeRepository homeRepo, StoredDataRepository storedDataRepo)
      : super((params) async {
        final login = await storedDataRepo.getCurrentLoginDetail();
        if (login == null) throw NotLoggedInException();
        return homeRepo.getPaymentUrl(login, params!);
      });
}