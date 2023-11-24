
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdv2_showcase_mobile/app/util/constants.dart';
import 'package:tdv2_showcase_mobile/data/model/notifiable_device_model.dart';
import 'package:tdv2_showcase_mobile/data/util/http_request.dart';
import 'package:tdv2_showcase_mobile/domain/repo/login_repository.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/login_usecase.dart';

class DataLoginRepository implements LoginRepository {

  static const _instance = DataLoginRepository._internal();
  const DataLoginRepository._internal();
  factory DataLoginRepository() => _instance;

  @override
  Future<LoginUseCaseResponse> login(String phoneNumber, String meta) async {
    final request = HttpRequestUtil(APIEndpoint.check);
    final response = await request([phoneNumber, meta]);

    final data = response['data'];
    final status = data['status'] as bool;
    final fazpassId = data['fazpass_id'] as String;
    final notifiableDevices = (data['notifiable_devices'] as List?)
        ?.map((e) => NotifiableDeviceModel.fromJson(e).toEntity()).toList();
    log(notifiableDevices.toString(), name: 'Notifiable device', level: 800);

    if (status && fazpassId.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('phone', phoneNumber);
      prefs.setString('fazpass_id', fazpassId);
      prefs.setBool('is_logged_in', true);
      return LoginUseCaseResponse(true, meta, []);
    }

    return LoginUseCaseResponse(false, meta, notifiableDevices ?? []);
  }

  @override
  Future<String> requestOtp(String phoneNumber) async {
    if (phoneNumber == Constants.fakePhoneNumber) {
      return 'fakeotpid';
    }

    final request = HttpRequestUtil(APIEndpoint.requestOtp);
    final response = await request([phoneNumber]);

    final data = response['data'];
    final otpId = data['otp_id'];

    return otpId;
  }

  @override
  Future<bool> validateOtp(String phoneNumber, String meta, String otpId, String otp) async {
    if (phoneNumber == Constants.fakePhoneNumber) {
      if (otp == Constants.fakeOtpVerifyNumber) {
        return true;
      }
    } else {
      final request = HttpRequestUtil(APIEndpoint.validateOtp);
      try {
        final response = await request([otp, otpId]);
        final status = response['status'] as bool;
        return status;
      } on HttpException {
        return false;
      }
    }

    return false;
  }

  @override
  Future<bool> enroll(String phoneNumber, String meta) async {
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

  @override
  Future<bool> sendNotification(String phoneNumber, String meta, String selectedDevice) async {
    final request = HttpRequestUtil(APIEndpoint.sendNotification);
    final response = await request([phoneNumber, meta, selectedDevice]);

    final status = response['status'] as bool?;

    return status ?? false;
  }

  @override
  Future<bool> validateNotification(String notificationId, String meta, bool answer) async {
    final request = HttpRequestUtil(APIEndpoint.validateNotification);

    try {
      final response = await request([notificationId, meta, answer]);
      final status = response['status'] as bool;
      return status;
    } on HttpException {
      return false;
    }
  }

}