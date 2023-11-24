
import 'package:tdv2_showcase_mobile/domain/entity/product.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/home_repository.dart';

class GetProductsUseCase extends OneTimeUseCase<List<Product>, void> {
  GetProductsUseCase(HomeRepository repo) : super((param) => repo.getProducts());
}