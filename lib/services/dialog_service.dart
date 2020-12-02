import 'dart:async';

import 'package:delivery_app/locator.dart';
import 'package:delivery_app/services/navigation_service.dart';

class DialogService {
  Function _showDialogListener;
  Completer _dialogCompleter;

  /// Registers a callback function. Typically to show the dialog
  void registerDialogListener(Function showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future showDialog() {
    _dialogCompleter = Completer();
    _showDialogListener();
    return _dialogCompleter.future;
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  void dialogComplete() {
    locator<NavigationService>().navigatePop();
    _dialogCompleter.complete();
    _dialogCompleter = null;
  }
}
