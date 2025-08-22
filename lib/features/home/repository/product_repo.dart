import 'package:online_shop/features/home/model/product.dart';
import 'package:online_shop/features/home/repository/product_api_repo.dart';
import 'package:online_shop/features/home/repository/product_local_repo.dart';

class ProductRepo {
  final ProductApiRepo _apiRepo;
  final ProductLocalRepo _localRepo;

  ProductRepo({
    required ProductApiRepo apiRepo,
    required ProductLocalRepo localRepo,
  }) : _apiRepo = apiRepo,
       _localRepo = localRepo;

  /// 1. FetchAPIProducts Function
  // This function will fetch the details of products from the API
  Future<List<Product>> fetchAPIProducts() async {
    return await _apiRepo.fetchProducts();
  }

  /// 2. FetchLocalDetails Function
  // This function will fetch the details from the local cache storage
  (int?, List<Product>?) fetchLocalDetails() {
    return _localRepo.fetchDetails();
  }

  /// 3. AddProductsAtLocal Function
  // This function will add the product details in the local storage
  Future<void> addProductsAtLocal(List<Product> products) async {
    // Deleting old Details and then adding new data to the local storage
    await _localRepo.deleteData();
    await _localRepo.addData(products);
  }
}
