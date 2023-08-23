
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
  Future<String> login(String phoneNumber, String meta) async {
    final uri = Uri.parse('https://seamless-pub.stg.fazpas.com/login');
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
      print(data);
      return data['data']['otp_id'];
    }

    throw HttpException(response.body, uri: uri);
  }

  @override
  Future<bool> validateOtp(String phoneNumber, String meta, String otpId, String otp) async {
    final uri = Uri.parse('https://seamless-pub.stg.fazpas.com/validate-otp');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "phone": phoneNumber,
        "meta": meta,
        "otp": otp,
        "otp_id": otpId
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final status = data['status'] as bool;

      if (status) {
        final fazpassId = data['data']['fazpass_id'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        await prefs.setString('phone', phoneNumber);
        await prefs.setString('fazpass_id', fazpassId);
      }

      return status;
    }

    throw HttpException(response.body, uri: uri);
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

}