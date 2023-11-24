
import 'package:tdv2_showcase_mobile/domain/entity/category.dart';
import 'package:tdv2_showcase_mobile/domain/entity/product.dart';
import 'package:tdv2_showcase_mobile/domain/entity/promo.dart';
import 'package:tdv2_showcase_mobile/domain/entity/tenant.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/validate_usecase.dart';

abstract interface class HomeRepository {
  /// { "status": true, "code": 200, "score": "90.0" }
  /// return score
  Future<ValidateUseCaseResponse> validate(String meta);
  /// { "status": true, "code": 200 }
  /// return status
  Future<bool> removeDevice(String meta);

  Future<bool> logout();

  Future<String> getPaymentUrl(int topupAmount);

  Future<bool> validateNotification(String meta, String receiverId, bool answer);

  Future<List<Promo>> getPromos();
  Future<List<Product>> getProducts();
  Future<List<Category>> getCategories();
  Future<List<Tenant>> getTenants();
}