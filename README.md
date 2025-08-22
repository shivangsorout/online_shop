# online_shop

online_shop is an e-commerce Flutter application.

https://github.com/user-attachments/assets/97cfa9e8-802a-49de-b9c1-83b829262cc8

# Building and Running the Flutter Application

## Prerequisites:
Before you begin, ensure you have the following installed:
- **Flutter SDK:** Follow the official Flutter installation instructions for your operating system.
- **Dart SDK:** Flutter requires the Dart SDK. It's included with the Flutter SDK, so you don't need to install it separately.
- **Android Studio/VS code or Xcode:** Depending on whether you're targeting Android or iOS, you'll need either Android Studio/VS code or Xcode installed.

## Getting Started:
1. Clone the repository:
	```
	git clone https://github.com/shivangsorout/online_shop.git
	```
2. Navigate to the project directory:
	```
	cd <project_directory>
	```
3. Install dependencies:
	```
	flutter pub get
	```

## Running the Application:
- **Android**   
  - Ensure you have an Android device connected via USB or an Android emulator running.   

  - Run the command in the terminal:
   ```
   flutter run
   ```
- **iOS**   
  - Ensure you have a macOS machine with Xcode installed.   

  - Run the command in the terminal:
   ```
   flutter run
   ```

## Architecture of the data layer:
I have used the MVVM architecture with the repository pattern.
- **Model:** The app has the **Product** data model, which has the basic product details(e.g., name, description, price, etc.).
- **Repository:** The app has a unified repository class named **ProductRepo**, which has the required methods for fetching data from the cache and from the API. The app has further delegated API calls to the **ProductApiRepo** class and local cache calls to the **ProductLocalRepo** class.
- **View:** The UI has only the Home screen, and this Home screen reacts to the changes in the **ProductViewModel**, and the app listens to these changes via Provider state management.
- **View Model:** This layer(**ProductViewModel**) has the responsibility of handling the UI states and product fetches either from the API or from the local storage. This layer is responsible for handling all errors and determining whether the application is loading from cache or fetching data from the API.

## State Management Solution:
I have used the Provider state management solution for the following reasons:
- **Streamlined State Management:** Reduces the boilerplate code needed for managing and sharing state.
- **Automatic Rebuilds:** Widgets update seamlessly whenever the state they depend on changes. So that is why it's suitable for handling a multi-source, asynchronous data flow, as automatic rebuilding helped me first show the cached data and showing the fresh API data afterwards.
- **Dependency Injection:** Efficiently manage objects and dependencies, improving code reusability and maintainability. This reason helped me to encapsulate the **ProductAPIRepo** and **ProductLocalRepo** from the **ProductViewModel**, as it only depends on the **ProductRepo**, which depends on those two repo.
- **Easy to learn and set up:** Provider's straightforward approach makes it beginner-friendly, serving as a great entry point for state management in Flutter. Also, it's very easy to set up compared to BLOC state management solution.
- **Scalable:** Whether you're building a small app or a large, complex one, Provider scales effectively to meet your needs.

In short, Provider is a solid mix of simplicity and power, making it the best reliable choice for me for this application.

## Caching:
I have used Hive for caching the data in local storage because it has very fast read and write speed, as compared to SharedPreferences, and is less complex as compared to Isar, as I don't have to perform any complex operations with the cached data. So that's why Hive is the best choice for this application.

## Staleness Detection:
I have used Flutter's Timer class periodic constructor, as I have to repeatedly check for the staleness every 5 minutes and update the products list with fresh data. So I have stored the **products** list as well as the **lastUpdateTime** as an Epoch timestamp in milliseconds. So after every five minutes, the periodic constructor has a callback function inside, which checks if the data is older than five minutes from the present time. If so, then a data refresh has been triggered. Following is the code for that:
```
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
```

## Reproducing different states and errors:
- **States:**
  - **"Loading from cache":** To reproduce this state, either you can uninstall the application to delete the cache from your local device storage to see an empty cache, or you can directly **Hot Restart** the application in debug mode to trigger this state, as the data always gets loaded from the cache in every fresh start of the application.
  - **"Fetching from Network" and "Up-to-date":** You can trigger these states either by hot restarting the application or by pressing the refresh floating action button at the bottom right of the home screen. These two states reproduce one after the other.

- **Errors:**
  - **NoInternetConnectionProductException:** To reproduce this error, simply turn off your device's internet and wifi connection, and now try to refresh the app using the floating action button on the bottom right.
  - **InvalidStatusCodeProductException:** To reproduce this error, change the baseUrl in "online_shop\lib\features\home\repository\product_api_repo.dart". Add "1" at the end of the baseUrl, making it as

    ```
    'https://dummyjson.com/products1';
    ```
    And now press the refresh floating action button.
  - **GenericProductException:** To reproduce this error, change the "json['products'] as List" to:

    ```
    json['products'] as Set
    ```
    at line number 34 in file "online_shop\lib\features\home\repository\product_api_repo.dart". And now refresh the data again using the floating action button.

