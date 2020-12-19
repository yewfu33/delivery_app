import 'package:delivery_app/constants.dart';
import 'package:delivery_app/services/dialog_service.dart';
import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  final DialogService dialogService = DialogService();

  bool _loading = false;
  get loading => _loading;

  void onLoading(bool isLoading, BuildContext context) {
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
              child: Text("OK",
                  style: const TextStyle(color: Constant.primaryColor)),
              onPressed: () => Navigator.pop(_),
            ),
          ],
        );
      },
    );
  }
}
