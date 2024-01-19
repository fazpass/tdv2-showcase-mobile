
import 'package:tdv2_showcase_mobile/domain/entity/login_detail.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/validate_usecase.dart';

abstract interface class HomeRepository {
  /// { "status": true, "code": 200, "score": "90.0" }
  /// return score
  Future<ValidateUseCaseResponse> validate(LoginDetail login, String meta);
  /// { "status": true, "code": 200 }
  /// return status
  Future<bool> removeDevice(LoginDetail login, String meta);

  Future<String> getPaymentUrl(LoginDetail login, int topupAmount);

  Future<bool> validateNotification(String meta, String receiverId, bool answer);
}