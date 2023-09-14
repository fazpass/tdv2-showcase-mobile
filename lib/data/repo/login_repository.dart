
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdv2_showcase_mobile/app/util/constants.dart';
import 'package:tdv2_showcase_mobile/data/util/http_request.dart';
import 'package:tdv2_showcase_mobile/domain/repo/login_repository.dart';

class DataLoginRepository implements LoginRepository {

  static const _instance = DataLoginRepository._internal();
  const DataLoginRepository._internal();
  factory DataLoginRepository() => _instance;

  @override
  Future<bool> login(String phoneNumber, String meta) async {
    final request = HttpRequestUtil(APIEndpoint.check);
    final response = await request([phoneNumber, meta]);

    final data = response['data'];
    final status = data['status'] as bool;
    final fazpassId = data['fazpass_id'] as String;

    if (status && fazpassId.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('phone', phoneNumber);
      prefs.setString('fazpass_id', fazpassId);
      prefs.setBool('is_logged_in', true);
      return true;
    }

    return false;
  }

  @override
  Future<String> requestOtp(String phoneNumber) async {
    if (phoneNumber == Constants.fakePhoneNumber) {
      return 'fakeotpid';
    }

    final request = HttpRequestUtil(APIEndpoint.requestOtp);
    final response = await request([phoneNumber]);

    final data = response['data'];
    return data['otp_id'];
  }

  @override
  Future<bool> verifyLogin(String phoneNumber, String meta, String otpId, String otp) async {
    if (phoneNumber == Constants.fakePhoneNumber) {
      if (otp == Constants.fakeOtpVerifyNumber) {
        return await _enroll(phoneNumber, meta);
      }
    } else {
      final validateOtpRequest = HttpRequestUtil(APIEndpoint.validateOtp);
      try {
        await validateOtpRequest([otp, otpId]);
        return await _enroll(phoneNumber, meta);
      } on HttpException {
        return false;
      }
    }

    return false;
  }

  Future<bool> _enroll(String phoneNumber, String meta) async {
    final enrollRequest = HttpRequestUtil(APIEndpoint.enroll);
    final enrollResponse = await enrollRequest([phoneNumber, meta]);

    final data = enrollResponse['data'];
    final fazpassId = data['fazpass_id'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', phoneNumber);
    await prefs.setString('fazpass_id', fazpassId);
    await prefs.setBool('is_logged_in', true);

    return true;
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

}