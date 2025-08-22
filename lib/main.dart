import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:online_shop/features/home/repository/product_api_repo.dart';
import 'package:online_shop/features/home/repository/product_local_repo.dart';
import 'package:online_shop/features/home/repository/product_repo.dart';
import 'package:online_shop/features/home/view/pages/home.dart';
import 'package:online_shop/features/home/view_model/product_view_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Getting cache directory path to setup and initialize the hive local storage path
  Directory directory = await getApplicationCacheDirectory();
  Hive.init(directory.path);

  // Opening the "local_storage" box for storing the data
  final cacheBox = await Hive.openBox('local_storage');
  runApp(
    MultiProvider(
      providers: [
        // Created this provider so that I don't have to add the implementation of ProductRepo in ProductViewModel
        Provider<ProductRepo>(
          create: (_) => ProductRepo(
            apiRepo: ProductApiRepo(),
            // Here I am using the box that I have opened for local cache.
            localRepo: ProductLocalRepo(cacheBox),
          ),
        ),
        ChangeNotifierProvider<ProductViewModel>(
          create: (context) =>
              ProductViewModel(context.read<ProductRepo>())..fetchProducts(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Online Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Home(),
    );
  }
}
