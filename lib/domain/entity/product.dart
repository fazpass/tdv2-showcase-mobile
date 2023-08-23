
import 'package:intl/intl.dart';

import 'category.dart';

class Product {
  String date;
  String name;
  num price;
  String imageUrl;
  List<Category> categories;

  int count = 0;

  Product(this.date, this.name, this.price, this.imageUrl, this.categories);

  String get formattedPrice => NumberFormat.currency(locale: "id-ID").format(price);
}