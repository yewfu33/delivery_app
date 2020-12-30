import 'package:delivery_app/view_model/addorder_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'MyInputDecoration.dart';

class NotifyPreferences extends StatefulWidget {
  const NotifyPreferences({
    Key key,
  }) : super(key: key);

  @override
  _NotifyPreferencesState createState() => _NotifyPreferencesState();
}

class _NotifyPreferencesState extends State<NotifyPreferences> {
  bool notifyMe = false;
  bool notifyRecipient = false;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AddOrderViewModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
      child: Container(
        child: Column(
          children: <Widget>[
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     Text(
            //       'Notify me by SMS',
            //       style: customInputStyle(fontSize: 16),
            //     ),
            //     Switch(
            //       activeColor: Constant.primaryColor,
            //       value: notifyMe,
            //       onChanged: (_) {
            //         model.notifySenderOnChanged();
            //         setState(() {
            //           notifyMe = !notifyMe;
            //         });
            //       },
            //     ),
            //   ],
            // ),
            // const Divider(height: 5, thickness: 1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Notify recipient by SMS',
                  style: customInputStyle(fontSize: 16),
                ),
                Switch(
                  activeColor: Constant.primaryColor,
                  value: notifyRecipient,
                  onChanged: (_) {
                    model.notifyRecipientOnChanged();
                    setState(() {
                      notifyRecipient = !notifyRecipient;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
