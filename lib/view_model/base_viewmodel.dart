import 'package:delivery_app/constants.dart';
import 'package:delivery_app/locator.dart';
import 'package:delivery_app/services/dialog_service.dart';
import 'package:delivery_app/services/navigation_service.dart';
import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  final DialogService dialogService = locator<DialogService>();

  bool _loading = false;
  get loading => _loading;

  void onLoading(bool isLoading) {
    if (isLoading) {
      dialogService.showDialog();
    } else {
      dialogService.dialogComplete();
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
          title: Text("Error"),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text("OK", style: TextStyle(color: Constant.primaryColor)),
              onPressed: () {
                locator<NavigationService>().navigatePop();
              },
            ),
          ],
        );
      },
    );
  }
}
