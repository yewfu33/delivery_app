import 'package:delivery_app/constants.dart';
import 'package:delivery_app/services/dialog_service.dart';
import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  final DialogService dialogService = DialogService();

  final bool _loading = false;
  bool get loading => _loading;

  void onLoading(BuildContext context, {bool isLoading}) {
    if (isLoading) {
      dialogService.showDialog();
    } else {
      dialogService.dialogComplete(context);
    }
  }

  void showErrorDialog(BuildContext context,
      {String message = "Please verify entered information is correct."}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(_),
              child: const Text("OK",
                  style: TextStyle(color: Constant.primaryColor)),
            ),
          ],
        );
      },
    );
  }
}
