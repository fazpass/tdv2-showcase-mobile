
import 'dart:convert';

import 'package:tdv2_showcase_mobile/data/util/http_request.dart';
import 'package:tdv2_showcase_mobile/domain/entity/login_detail.dart';
import 'package:tdv2_showcase_mobile/domain/repo/home_repository.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/validate_usecase.dart';
import 'package:tdv2_showcase_mobile/exception.dart';

class DataHomeRepository implements HomeRepository {
  
  static const _instance = DataHomeRepository._internal();
  const DataHomeRepository._internal();
  factory DataHomeRepository() => _instance;
  
  @override
  Future<bool> removeDevice(LoginDetail login, String meta) async {
    final checkRequest = HttpRequestUtil(APIEndpoint.check);
    final checkResponse = await checkRequest([login.phone, meta]);

    final checkData = checkResponse['data'];
    final status = checkData['status'] as bool;

    if (!status) throw CheckFailedException();

    final challenge = checkData['challenge'] as String;
    final request = HttpRequestUtil(APIEndpoint.logout);
    final response = await request([login.phone, meta, login.fazpassId, challenge]);

    return response['status'] as bool;
  }

  @override
  Future<ValidateUseCaseResponse> validate(LoginDetail login, String meta) async {
    final checkRequest = HttpRequestUtil(APIEndpoint.check);
    final checkResponse = await checkRequest([login.phone, meta]);

    final checkData = checkResponse['data'];
    final status = checkData['status'] as bool;

    if (!status) throw CheckFailedException();

    final challenge = checkData['challenge'] as String;
    final request = HttpRequestUtil(APIEndpoint.validateUser);
    final response = await request([login.phone, meta, login.fazpassId, challenge]);

    final data = response['data'];
    return ValidateUseCaseResponse(data['score'] as double, data['risk_level']);
  }

  @override
  Future<String> getPaymentUrl(LoginDetail login, int topupAmount) async {
    print('getting payment url');
    final request = HttpRequestUtil(APIEndpoint.getPaymentUrl, headers: {
      'Accept': 'application/json',
      'Authorization':' Basic ${utf8.fuse(base64).encode('SB-Mid-server-Hxn-SSdJ5J2OTr4UBJ04eLa6:')}'
    });
    print('request made');
    final response = await request([
      {
        "order_id": 'id-${DateTime.now().millisecondsSinceEpoch}',
        "gross_amount": topupAmount.toDouble(),
      },
      [
        {
          "id": 1,
          "price": topupAmount.toDouble(),
          "quantity": 1,
          "name": 'Topup',
          "merchant_name": "E-Wallet"
        }
      ],
      {
        "first_name": 'User',
        "last_name": '',
        "email": 'user@mail.com',
        "phone": login.phone,
      },
      {},
      {
        "enable_callback": true,
      }
    ]);
    print(response);

    return response['redirect_url'];
  }

  @override
  Future<bool> validateNotification(String meta, String receiverId, bool answer) async {
    final request = HttpRequestUtil(APIEndpoint.validateNotification);
    final response = await request([receiverId, meta, answer]);

    return response['status'] as bool? ?? false;
  }

}