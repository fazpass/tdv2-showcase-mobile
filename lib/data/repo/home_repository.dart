
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdv2_showcase_mobile/domain/entity/category.dart';
import 'package:tdv2_showcase_mobile/domain/entity/product.dart';
import 'package:tdv2_showcase_mobile/domain/entity/promo.dart';
import 'package:tdv2_showcase_mobile/domain/entity/tenant.dart';
import 'package:tdv2_showcase_mobile/domain/entity/validate_result.dart';
import 'package:tdv2_showcase_mobile/domain/repo/home_repository.dart';

class DataHomeRepository implements HomeRepository {
  
  static const _instance = DataHomeRepository._internal();
  const DataHomeRepository._internal();
  factory DataHomeRepository() => _instance;

  @override
  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
  
  @override
  Future<bool> removeDevice(String meta) async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.getString('phone');
    final fazpassId = prefs.getString('fazpass_id');

    final uri = Uri.parse('https://seamless-pub.stg.fazpas.com/logout');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "phone": phoneNumber,
        "meta": meta,
        "fazpass_id": fazpassId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final status = data['status'] as bool;
      if (status) await prefs.clear();
      return status;
    }

    throw HttpException(response.body, uri: uri);
  }

  @override
  Future<ValidateResult> validate(String meta) async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.getString('phone');
    final fazpassId = prefs.getString('fazpass_id');

    final uri = Uri.parse('https://seamless-pub.stg.fazpas.com/validate-user');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "phone": phoneNumber,
        "meta": meta,
        "fazpass_id": fazpassId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ValidateResult(data['data']['score'], data['data']['risk_level']);
    }

    throw HttpException(response.body, uri: uri);
  }

  @override
  Future<String> getPaymentUrl(int topupAmount) async {
    Map data = {
      "transaction_details": {
        "order_id": 'id-${DateTime.now().millisecondsSinceEpoch}',
        "gross_amount": topupAmount.toDouble(),
      },
      "item_details": [
        {
          "id": 1,
          "price": topupAmount.toDouble(),
          "quantity": 1,
          "name": 'Topup',
          "merchant_name": "Marketplacebo"
        }
      ],
      "customer_details": {
        "first_name": 'User',
        "last_name": '',
        "email": 'user@mail.com',
        "phone": '0812345678890',
      },
      "callbacks": {
      },
      "gopay": {
        "enable_callback": true,
      }
    };

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    Uri uri = Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions');
    final response = await http.post(
        uri,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':' Basic ${stringToBase64.encode('SB-Mid-server-Hxn-SSdJ5J2OTr4UBJ04eLa6:')}'
        },
        body: jsonEncode(data)
    );

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201) {
      return jsonDecode(response.body)['redirect_url'];
    }

    throw HttpException(response.body, uri: uri);
  }

  @override
  Future<List<Promo>> getPromos() {
    return Future.delayed(const Duration(seconds: 1), () => [
      Promo('16-08-2023', '20-08-2023', 'Get a huge discount for our recommended cosmetics pick!', 'https://firebasestorage.googleapis.com/v0/b/fazpass-product.appspot.com/o/cosmetics.jpg?alt=media&token=bcb94716-aabb-49ec-ada1-9cc125cc5e04'),
      Promo('16-08-2023', '20-08-2023', 'Get 20% off by joining our membership!', 'https://firebasestorage.googleapis.com/v0/b/fazpass-product.appspot.com/o/pancake.jpg?alt=media&token=2a6035bb-e8c5-4eeb-a351-3425802cb19b'),
    ]);
  }

  @override
  Future<List<Product>> getProducts() {
    return Future.delayed(const Duration(seconds: 2), () => [
      Product(
        '16-08-2023',
        'Biur-I A set',
        50000,
        'https://firebasestorage.googleapis.com/v0/b/fazpass-product.appspot.com/o/cosmetics.jpg?alt=media&token=bcb94716-aabb-49ec-ada1-9cc125cc5e04',
        [],
      ),
      Product(
        '16-08-2023',
        'Dessert\'s & co. Pancake',
        20000,
        'https://firebasestorage.googleapis.com/v0/b/fazpass-product.appspot.com/o/pancake.jpg?alt=media&token=2a6035bb-e8c5-4eeb-a351-3425802cb19b',
        [],
      ),
      Product(
        '16-08-2023',
        'Dessert\'s & co. Custom Bread',
        10000,
        'https://firebasestorage.googleapis.com/v0/b/fazpass-product.appspot.com/o/bread.jpg?alt=media&token=18e93459-880b-435d-b816-7ac9f3316efc',
        [],
      ),
      Product(
        '16-08-2023',
        'Mount\'n Rider Daily Bike',
        1000000,
        'https://firebasestorage.googleapis.com/v0/b/fazpass-product.appspot.com/o/bike.jpg?alt=media&token=15fcd0b3-8ddb-419d-a458-15e058507487',
        [],
      ),
      Product(
        '16-08-2023',
        'Mount\'n Rider Mountain Bike',
        2000000,
        'https://firebasestorage.googleapis.com/v0/b/fazpass-product.appspot.com/o/mountain-bike.jpg?alt=media&token=b195bc0a-6f1f-4e37-9084-818b68f9b8b7',
        [],
      ),
    ]);
  }

  @override
  Future<List<Category>> getCategories() {
    return Future.delayed(const Duration(seconds: 3), () => [
      Category('Cosmetics & Beauty', 'https://firebasestorage.googleapis.com/v0/b/fazpass-product.appspot.com/o/cosmetics.jpg?alt=media&token=bcb94716-aabb-49ec-ada1-9cc125cc5e04'),
      Category('Food', 'https://firebasestorage.googleapis.com/v0/b/fazpass-product.appspot.com/o/pancake.jpg?alt=media&token=2a6035bb-e8c5-4eeb-a351-3425802cb19b'),
      Category('Bike', 'https://firebasestorage.googleapis.com/v0/b/fazpass-product.appspot.com/o/bike.jpg?alt=media&token=15fcd0b3-8ddb-419d-a458-15e058507487'),
    ]);
  }

  @override
  Future<List<Tenant>> getTenants() {
    return Future.delayed(const Duration(seconds: 4), () => [
      Tenant('Biur-I Official', 'Central Jakarta', 'https://firebasestorage.googleapis.com/v0/b/fazpass-product.appspot.com/o/cosmetics.jpg?alt=media&token=bcb94716-aabb-49ec-ada1-9cc125cc5e04'),
      Tenant('Dessert\'s & co.', 'West Java', 'https://firebasestorage.googleapis.com/v0/b/fazpass-product.appspot.com/o/pancake.jpg?alt=media&token=2a6035bb-e8c5-4eeb-a351-3425802cb19b'),
      Tenant('Mount\'n Rider', 'Central Java', 'https://firebasestorage.googleapis.com/v0/b/fazpass-product.appspot.com/o/mountain-bike.jpg?alt=media&token=b195bc0a-6f1f-4e37-9084-818b68f9b8b7'),
    ]);
  }

}