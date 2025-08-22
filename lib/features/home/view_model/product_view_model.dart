import 'package:flutter/foundation.dart';
import 'package:online_shop/core/helpers/helper.dart';
import 'package:online_shop/features/home/model/product.dart';
import 'package:online_shop/features/home/repository/product_exceptions.dart';
import 'package:online_shop/features/home/repository/product_repo.dart';
import 'dart:developer' as devtool show log;

class ProductViewModel extends ChangeNotifier {
  final ProductRepo _productRepo;

  List<Product> _products = []; // For saving products list state
  int _lastTimeUpdated = -1; // For saving last update time of storage
  bool _isLoading = false;
  String _errorMessage = ''; // For displaying the error if any occur in the app
  String _stateMessage =
      ''; // For displaying the state of the application via snackbar

  ProductViewModel(this._productRepo);

  /// Getters
  List<Product> get products => _products;
  int get lastTimeUpdated => _lastTimeUpdated;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get stateMessage => _stateMessage;

  /// 1. FetchProducts function.
  /// This function is responsible for fetching products details from the cache as well as API.
  Future<void> fetchProducts() async {
    try {
      // First we will fetch the details from the local cache
      _isLoading = true;

      // Delay for the snackbar
      await Future.delayed(Duration(milliseconds: 300));

      // Here I am using the Helper() because I have defined it as singleton so I am using same instance all over the app.
      _stateMessage = Helper().applicationStates(localLoadCaseKey);
      // Logging in debug console
      devtool.log(Helper().applicationStates(localLoadCaseKey));
      notifyListeners();

      (int, List<Product>) localData1 = _productRepo.fetchLocalDetails();

      // Accessing 2nd property from local data and checking if local cache has list of products or it is empty
      if (localData1.$2.isNotEmpty) {
        // Assigning the values to products and lastTimeUpdated variable and setting isLoading to False
        _products = localData1.$2;
        _lastTimeUpdated = localData1.$1;
        _isLoading = false;
        notifyListeners();
      }

      // For simulating network latency
      await Future.delayed(Duration(seconds: 3));

      // After Loading from the cache now we will fetch the fresh data from the api

      // Updating the application status
      _stateMessage = Helper().applicationStates(apiLoadCaseKey);
      devtool.log(Helper().applicationStates(apiLoadCaseKey));
      notifyListeners();

      _productRepo
          .fetchAPIProducts()
          .then((products) async {
            // After fetching from the api we are updating the data in local storage
            await _productRepo.updateDataAtLocal(products);

            // Here we are updating the products list and last update time with new fresh data
            (int, List<Product>) localData2 = _productRepo.fetchLocalDetails();

            // Assigning the values to products and lastTimeUpdated variable and setting isLoading to False
            _products = localData2.$2;
            _lastTimeUpdated = localData2.$1;
            _isLoading = false;

            // Updating the application status and Logging in debug console
            _stateMessage = Helper().applicationStates(upToDateCaseKey);
            devtool.log(Helper().applicationStates(upToDateCaseKey));
            notifyListeners();
          })
          .catchError((error) {
            _showAndLogErrorMessage(
              'Failed to fetch products. Please try again!',
            );
          }, test: (error) => error is InvalidStatusCodeProductException)
          .catchError((error) {
            _showAndLogErrorMessage(
              'Please turn on your internet and then try again!',
            );
          }, test: (error) => error is NoInternetConnectionProductException)
          .catchError((error) {
            _showAndLogErrorMessage(
              'Error while fetching products list. Please try again!',
            );
          }, test: (error) => error is GenericProductException);
    } catch (_) {
      _showAndLogErrorMessage(
        'Error while fetching products list. Please try again!',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 2. RefreshProducts function.
  /// This function is responsible for fresh data loading from api to local storage.
  Future<void> refreshProducts() async {
    try {
      // Updating state message
      _stateMessage = Helper().applicationStates(apiLoadCaseKey);
      devtool.log(Helper().applicationStates(apiLoadCaseKey));
      notifyListeners();
      List<Product> apiProductsList = await _productRepo.fetchAPIProducts();

      // After fetching from the api we are updating the data in local storage
      await _productRepo.updateDataAtLocal(apiProductsList);

      // Here we are updating the products list and last update time with new fresh data
      (int, List<Product>) localData = _productRepo.fetchLocalDetails();
      _products = localData.$2;
      _lastTimeUpdated = localData.$1;
      _isLoading = false;
      // Updating state of the application as well as logging it in the debug console
      _stateMessage = Helper().applicationStates(upToDateCaseKey);
      devtool.log(Helper().applicationStates(upToDateCaseKey));
      notifyListeners();
    } on InvalidStatusCodeProductException {
      _showAndLogErrorMessage('Failed to fetch products. Please try again!');
    } on NoInternetConnectionProductException {
      _showAndLogErrorMessage(
        'Please turn on your internet and then try again!',
      );
    } on GenericProductException {
      _showAndLogErrorMessage(
        'Error while fetching products list. Please try again!',
      );
    }
  }

  /// 3. ClearMessage.
  /// This function will clear State message.
  void clearMessage() {
    _stateMessage = '';
    notifyListeners();
  }

  /// 4. ClearErrorMessage.
  /// This function will clear Error message.
  void clearErrorMessage() {
    _errorMessage = '';
    notifyListeners();
  }

  /// ShowAndLogErrorMessage.
  /// Helper function for this view model.
  void _showAndLogErrorMessage(String message) {
    _errorMessage = message;
    devtool.log("Error: $message");
    notifyListeners();
  }
}
