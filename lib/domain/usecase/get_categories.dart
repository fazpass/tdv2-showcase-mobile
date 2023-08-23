
import 'package:tdv2_showcase_mobile/domain/entity/category.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/home_repository.dart';

class GetCategoriesUseCase extends OneTimeUseCase<List<Category>, void> {
  GetCategoriesUseCase(HomeRepository repo) : super((param) => repo.getCategories());
}