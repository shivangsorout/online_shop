import 'dart:convert';
import 'package:online_shop/features/home/model/product.dart';
import 'package:online_shop/features/home/repository/product_exceptions.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

class ProductApiRepo {
  // Declaring Singleton class
  factory ProductApiRepo() => sharedReference;
  static final sharedReference = ProductApiRepo._sharedInstance();
  ProductApiRepo._sharedInstance();

  final String baseUrl = 'https://dummyjson.com/products';

  // Get call for fetching the products list
  Future<List<Product>> fetchProducts() async {
    try {
      // To simulate the network latency
      await Future.delayed(Duration(seconds: 2));

      bool isInternetAvailable = await _isInternetAvailable();

      // Checking if internet is available or not
      if (isInternetAvailable) {
        // Getting the http response from the baseURl
        final response = await http.get(Uri.parse(baseUrl));

        // Checking if the call has successfully ended or it failed
        if (response.statusCode == 200) {
          // Parsing the json response into Map type
          final Map<String, dynamic> jsonData = jsonDecode(response.body);

          // Converting Json data into list of products
          List<Product> products = (jsonData['products'] as List)
              .map((productJson) => Product.fromJson(productJson))
              .toList();

          // Returning the list of the products
          return products;
        } else {
          throw InvalidStatusCodeProductException();
        }
      } else {
        throw NoInternetConnectionProductException();
      }
    } on InvalidStatusCodeProductException {
      rethrow;
    } on NoInternetConnectionProductException {
      rethrow;
    } catch (_) {
      throw GenericProductException();
    }
  }

  // Function for checking the internet connection
  Future<bool> _isInternetAvailable() async {
    final bool isConnected =
        await InternetConnectionChecker.instance.hasConnection;
    return isConnected;
  }
}
