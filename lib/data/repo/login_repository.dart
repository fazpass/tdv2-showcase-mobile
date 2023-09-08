
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdv2_showcase_mobile/domain/repo/login_repository.dart';
import 'package:http/http.dart' as http;

class DataLoginRepository implements LoginRepository {

  static const _instance = DataLoginRepository._internal();
  const DataLoginRepository._internal();
  factory DataLoginRepository() => _instance;

  @override
  Future<bool> login(String phoneNumber, String meta) async {
    final uri = Uri.parse('https://seamless-pub.stg.fazpas.com/check');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "phone": phoneNumber,
        "meta": meta,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final status = data['data']['status'] as bool;
      final fazpassId = data['data']['fazpass_id'] as String;

      if (status && fazpassId.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('phone', phoneNumber);
        prefs.setString('fazpass_id', fazpassId);
        prefs.setBool('is_logged_in', true);
        return true;
      }

      return false;
    }

    return false;
  }

  @override
  Future<String> requestOtp(String phoneNumber) async {
    final uri = Uri.parse('https://seamless-pub.stg.fazpas.com/request-otp');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "phone": phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['otp_id'];
    }

    throw HttpException(response.body, uri: uri);
  }

  @override
  Future<bool> validateOtpThenEnroll(String phoneNumber, String meta, String otpId, String otp) async {
    final uri = Uri.parse('https://seamless-pub.stg.fazpas.com/validate-otp');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "otp": otp,
        "otp_id": otpId
      }),
    );

    if (response.statusCode == 200) {
      final enrollUri = Uri.parse('https://seamless-pub.stg.fazpas.com/enroll');
      final enrollResponse = await http.post(
        enrollUri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "phone": phoneNumber,
          "meta": meta
        }),
      );

      if (enrollResponse.statusCode == 200) {
        final data = jsonDecode(enrollResponse.body);
        final fazpassId = data['data']['fazpass_id'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('phone', phoneNumber);
        await prefs.setString('fazpass_id', fazpassId);
        await prefs.setBool('is_logged_in', true);

        return true;
      }
    } else if (response.statusCode == 400) {
      return false;
    }

    throw HttpException(response.body, uri: uri);
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

}