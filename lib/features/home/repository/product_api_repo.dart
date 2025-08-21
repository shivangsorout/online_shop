class ProductApiRepo {
  // Declaring Singleton class
  factory ProductApiRepo() => sharedReference;
  static final sharedReference = ProductApiRepo._sharedInstance();
  ProductApiRepo._sharedInstance();

  final String baseUrl = 'https://dummyjson.com/products';
}
