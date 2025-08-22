import 'dart:async';

import 'package:flutter/material.dart';
import 'package:online_shop/core/extensions/media_query_extension.dart';
import 'package:online_shop/features/home/model/product.dart';
import 'package:online_shop/features/home/view/widgets/product_widget.dart';
import 'package:online_shop/features/home/view_model/product_view_model.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // Created this product view model's instance so I can add listeners to it.
    ProductViewModel productVM = Provider.of<ProductViewModel>(
      context,
      listen: false,
    );

    // Adding listener for application's state to show snackbar at any change
    productVM.addListener(_applicationStateHandler);

    // Adding listener for showing error if any occurs
    productVM.addListener(_errorHandler);

    // This function handles the data staleness. If it gets older than 5 minutes
    // then it will refresh the fresh products.
    _dataStalenessHandler(productVM);
    super.initState();
  }

  /// This function is to handle the staleness of the products data.
  void _dataStalenessHandler(ProductViewModel productVM) {
    // Here I have added the duration of 310 seconds which is 10 seconds more
    // than the 5 minutes because the callback funtion inside this takes some
    // time to execute as well so I have assumed it 10 seconds.
    Timer.periodic(Duration(seconds: 310), (_) {
      // Here I am checking if the lastTimeUpdated which is stored in Epoch
      // timestamps is stale by more than five minutes if so the products gets refreshed.
      if (productVM.lastTimeUpdated <
          (DateTime.now().millisecondsSinceEpoch - 300000)) {
        productVM.refreshProducts().whenComplete(() {
          // This is to bring back the scroll position to the start.
          _scrollController.jumpTo(0);
        });
      }
    });
  }

  @override
  void dispose() {
    ProductViewModel productVM = Provider.of<ProductViewModel>(
      context,
      listen: false,
    );
    // Disposing both the listener functions and the scroll controller as well.
    productVM.removeListener(_applicationStateHandler);
    productVM.removeListener(_errorHandler);
    _scrollController.dispose();
    super.dispose();
  }

  /// This function is to show the snackbar to show the different states of the app.
  void _applicationStateHandler() {
    final viewModel = Provider.of<ProductViewModel>(context, listen: false);
    // Checking if the stateMessage in ViewModel is empty or not.
    if (viewModel.stateMessage.isNotEmpty) {
      // Showing snackbar if the stateMessage has some state in it for 1 second.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.stateMessage),
          duration: Duration(seconds: 1),
        ),
      );
      // Clearing/Emptying the stateMessage in view model.
      viewModel.clearMessage();
    }
  }

  /// This functions handles the error message and show an alert dialog for it.
  void _errorHandler() {
    final viewModel = Provider.of<ProductViewModel>(context, listen: false);
    // Checking if the errorMessage in ViewModel is empty or not.
    if (viewModel.errorMessage.isNotEmpty) {
      // Showing alert dialog box with error details in it.
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Error',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
            ),
            content: Text(
              viewModel.errorMessage,
              style: TextStyle(fontSize: 17),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Ok'),
              ),
            ],
          );
        },
      ).whenComplete(() {
        // Clearing/Emptying the errorMessage in view model.
        viewModel.clearErrorMessage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Online Shop'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: viewModel.isLoading || viewModel.products.isEmpty
              ?
                // Loader widget for showing loader when isLoading is true or
                // products list is empty.
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Circular progress indicator with a Loading text
                            CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(height: 10),
                            Text('Loading..', style: TextStyle(fontSize: 15)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              :
                // Grid View to show the products list on the screen
                GridView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  // Setting the grid delegates to my UI need so that it looks great
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0.025 * context.mqSize.height,
                    crossAxisSpacing: 0.039 * context.mqSize.height,
                    childAspectRatio: 0.5,
                  ),
                  // Padding for vertical and horizontal offsets.
                  padding: EdgeInsets.symmetric(
                    vertical: 0.03 * context.mqSize.height,
                    horizontal: 0.046 * context.mqSize.height,
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: viewModel.products.length,
                  itemBuilder: (context, index) {
                    Product product = viewModel.products[index];
                    // My custom product card widget in which I have shown the
                    // following details.
                    return ProductWidget(
                      name: product.name,
                      description: product.description,
                      price: product.price,
                      rating: product.rating,
                      thumbnail: product.thumbnail,
                    );
                  },
                ),
          // Floating action button for refreshing the products list manually
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              viewModel.refreshProducts().whenComplete(() {
                _scrollController.jumpTo(0);
              });
            },
            child: Icon(Icons.replay),
          ),
        );
      },
    );
  }
}
