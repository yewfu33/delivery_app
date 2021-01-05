import 'dart:async';
import 'package:flutter/material.dart';

class DialogService {
  static final DialogService _singleton = DialogService._();

  // register sigleton instance
  factory DialogService() => _singleton;

  DialogService._();

  Function _showDialogListener;
  Completer _dialogCompleter;

  /// Registers a callback function. Typically to show the dialog
  set registerDialogListener(Function showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future showDialog() {
    _dialogCompleter = Completer();
    _showDialogListener();
    return _dialogCompleter.future;
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  void dialogComplete(BuildContext context) {
    Navigator.pop(context);
    _dialogCompleter.complete();
    _dialogCompleter = null;
  }
}
