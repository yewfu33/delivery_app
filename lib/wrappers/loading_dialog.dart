import 'package:delivery_app/constants.dart';
import 'package:delivery_app/services/dialog_service.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatefulWidget {
  final Widget child;
  const LoadingDialog({Key key, this.child}) : super(key: key);

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  final DialogService dialogService = DialogService();

  @override
  void initState() {
    super.initState();
    dialogService.registerDialogListener = _showDialog;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return WillPopScope(
          // will pop scope prevent back button fire
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0))),
            content: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Constant.primaryColor),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    "Loading...",
                    style: TextStyle(
                      letterSpacing: 0.3,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
