import 'package:hive/hive.dart';
import 'package:online_shop/features/home/model/product.dart';
// import 'dart:developer' as devtool show log;

class ProductLocalRepo {
  final Box _box;

  ProductLocalRepo(this._box);

  /// 1. FetchDetails Function
  // This function is returning a record of timestamp and list of products
  (int?, List<Product>?) fetchDetails() {
    int? lastUpdated = _box.get(lastTimeUpdatedKey);
    List<Product>? products = (_box.get(productsListKey) as List?)
        ?.map((json) => Product.fromJson(json))
        .toList();
    return (lastUpdated, products);
  }

  /// 2. AddData Function
  // This function is for adding the products and last updated time into hive
  Future<void> addData(List<Product> products) async {
    // Adding products data into the box
    await _box.put(
      productsListKey,
      products.map((product) => product.toJson()).toList(),
    );

    // Adding last updated time as milliseconds epoch timestamp
    await _box.put(lastTimeUpdatedKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// 3. DeleteData Function
  // This function is for deleting all data
  Future<void> deleteData() async {
    await _box.deleteAll([lastTimeUpdatedKey, productsListKey]);
  }
}

// Keys name constants
const lastTimeUpdatedKey = 'last_update';
const productsListKey = 'products';
