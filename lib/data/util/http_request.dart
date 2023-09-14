
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

enum APIEndpoint {
  /// Parameters:
  /// - [String] phone
  /// - [String] meta
  check(url: '$_base/check', successCode: 200, params: ['phone', 'meta']),
  /// Parameters:
  /// - [String] phone
  requestOtp(url: '$_base/request-otp', successCode: 200, params: ['phone']),
  /// Parameters:
  /// - [String] otp
  /// - [String] otp_id
  validateOtp(url: '$_base/validate-otp', successCode: 200, params: ['otp', 'otp_id']),
  /// Parameters:
  /// - [String] phone
  /// - [String] meta
  enroll(url: '$_base/enroll', successCode: 200, params: ['phone', 'meta']),
  /// Parameters:
  /// - [String] phone
  /// - [String] meta
  /// - [String] fazpass_id
  logout(url: '$_base/logout', successCode: 200, params: ['phone', 'meta', 'fazpass_id']),
  /// Parameters:
  /// - [String] phone
  /// - [String] meta
  /// - [String] fazpass_id
  validateUser(url: '$_base/validate-user', successCode: 200, params: ['phone', 'meta', 'fazpass_id']),
  /// Headers:
  /// - Accept
  /// - Authorization
  ///
  /// Parameters:
  /// - [Map] transaction_details
  /// - [List] item_details
  /// - [Map] customer_details
  /// - [Map] callbacks
  /// - [Map] gopay
  getPaymentUrl(url: 'https://app.sandbox.midtrans.com/snap/v1/transactions', successCode: 201, params: [
    'transaction_details',
    'item_details',
    'customer_details',
    'callbacks',
    'gopay',
  ]),;

  static const _base = 'https://seamless-pub.stg.fazpas.com';

  const APIEndpoint({required this.url, required this.successCode, required this.params});

  final String url;
  final int successCode;
  final List<String> params;
}

class HttpRequestUtil {
  final APIEndpoint api;
  final Map<String, String>? headers;

  HttpRequestUtil(this.api, {this.headers});

  Future<Map<String, dynamic>> call(List params) async {
    final uri = Uri.parse(api.url);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (headers != null) ...headers!,
      },
      body: jsonEncode({
        for (var i = 0; i < api.params.length; i++)
          api.params[i]: params[i],
      }),
    ).timeout(const Duration(seconds: 12));

    if (response.statusCode == api.successCode) {
      return jsonDecode(response.body);
    }

    throw HttpException(response.body, uri: uri);
  }
}