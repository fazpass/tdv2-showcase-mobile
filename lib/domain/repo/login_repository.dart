
abstract interface class LoginRepository {
  /// { "status": true, "code": 200, "otp_id": "id12345" }
  /// return otp_id
  Future<String> login(String phoneNumber, String meta);
  /// { "status": true, "code": 200, "fazpass_id": "fid12345" }
  /// return status
  Future<bool> validateOtp(String phoneNumber, String meta, String otpId, String otp);

  Future<bool> isLoggedIn();
}