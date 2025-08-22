import 'dart:developer' as devtool show log;

/// Singleton helper class for the app.
class Helper {
  /// Making this class as singleton
  // Start
  Helper._sharedInstance();
  static final sharedReference = Helper._sharedInstance();

  /// Singleton helper class for the app.
  factory Helper() => sharedReference;
  // End

  // A function that returns the application states string message
  String applicationStates(String state) {
    String stateString = '';
    switch (state) {
      case localLoadCaseKey:
        stateString = 'Loading from Cache';
        break;
      case apiLoadCaseKey:
        stateString = 'Fetching from Network';
        break;
      case upToDateCaseKey:
        stateString = 'Up-to-date';
        break;
      default:
        devtool.log('You have choose the wrong option!');
    }
    return stateString;
  }
}

/// Constants for the App's state switch cases
const localLoadCaseKey = 'localLoad';
const apiLoadCaseKey = 'apiLoad';
const upToDateCaseKey = 'upToDate';
