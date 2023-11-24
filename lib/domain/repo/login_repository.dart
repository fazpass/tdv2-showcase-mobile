
import 'package:tdv2_showcase_mobile/domain/usecase/login_usecase.dart';

abstract interface class LoginRepository {

  /// { "status": true, "code": 200, "fazpass_id": "id12345" }
  Future<LoginUseCaseResponse> login(String phoneNumber, String meta);
  /// { "status": true, "code": 200, "otp_id": "id12345" }
  /// return otp_id
  Future<String> requestOtp(String phoneNumber);
  /// { "status": true, "code": 200, "fazpass_id": "fid12345" }
  /// return status
  Future<bool> validateOtp(String phoneNumber, String meta, String otpId, String otp);
  /// { "status": true, "code": 200, "notification_id": "nid12345" }
  /// return status
  Future<bool> sendNotification(String phoneNumber, String meta, String selectedDevice);
  /// { "status": true, "code": 200, "message": "Lorem ipsum" }
  /// return status
  Future<bool> validateNotification(String notificationId, String meta, bool answer);
  /// { "status": true, "code": 200, "fazpass_id": "fid12345" }
  /// return status
  Future<bool> enroll(String phoneNumber, String meta);

  Future<bool> isLoggedIn();
}