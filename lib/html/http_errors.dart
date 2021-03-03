import 'package:rxdart/rxdart.dart';

BehaviorSubject<String> errorStreamController = BehaviorSubject<String>();

class HttpErrors {
  void checkError(int errorCode, String errorDescription) {
    if (errorCode != null) {
      errorStreamController.add('$errorCode$errorDescription');
    } else {
      errorStreamController.add('unknownCommunicationError');
    }
  }
}