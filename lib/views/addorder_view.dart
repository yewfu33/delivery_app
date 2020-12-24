import 'package:delivery_app/constants.dart';
import 'package:delivery_app/util.dart';
import 'package:delivery_app/view_model/addorder_viewmodel.dart';
import 'package:delivery_app/widgets/MyInputDecoration.dart';
import 'package:delivery_app/widgets/PickUpPointPanel.dart';
import 'package:delivery_app/widgets/VehicleTypePanel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddOrderView extends StatelessWidget {
  final Map weightSelect = <String, double>{
    'Less than 10KG': 0,
    'More than 10KG': 10,
    'More than 50KG': 50,
  };

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddOrderViewModel(),
      builder: (BuildContext context, _) {
        final model = context.watch<AddOrderViewModel>();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Add New Order'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              iconSize: 27.0,
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  model.formKey.currentState.reset();
                },
                child:
                    Text('Clear', style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
          bottomNavigationBar:
              BottomActionBar(callBack: () => model.saveOrder(context)),
          body: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 5.0),
              child: ScrollConfiguration(
                behavior: MyScrollBehavior(),
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Container(
                    child: Form(
                      key: model.formKey,
                      autovalidate: model.autoValidateForm,
                      child: Column(
                        children: <Widget>[
                          //vehicleType panel
                          const VehicleTypePanel(),
                          //name field
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 18),
                            child: TextFormField(
                              validator: (v) {
                                if (v.trim().isEmpty) {
                                  return 'This field is required';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (v) {
                                model.order.name = v;
                              },
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                labelText: 'What you want to deliver',
                                contentPadding: EdgeInsets.zero,
                                labelStyle: customInputStyle(),
                              ),
                            ),
                          ),
                          //weight field
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 18),
                            child: DropdownButtonFormField(
                              validator: (value) => value == null
                                  ? 'This field is required'
                                  : null,
                              decoration: InputDecoration(
                                labelText: 'Total weight',
                                labelStyle: customInputStyle(),
                                contentPadding: EdgeInsets.zero,
                              ),
                              items: [
                                for (var i in weightSelect.entries)
                                  DropdownMenuItem<double>(
                                    child: Text(i.key),
                                    value: i.value,
                                    key: Key(i.key),
                                  )
                              ],
                              onChanged: (v) {
                                model.order.weight = v;
                              },
                            ),
                          ),
                          //pick and drop section
                          const PickUpPointPanel(),
                          Divider(
                            height: 20,
                            color: Colors.grey[200],
                            thickness: 20,
                          ),
                          //notify preferences
                          const NotifyPreferences(),
                          Divider(
                            height: 20,
                            color: Colors.grey[200],
                            thickness: 20,
                          ),
                          //payment section
                          const PaymentSettingSection(),
                          Container(
                            height: 50,
                            color: Colors.grey[200],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NotifyPreferences extends StatefulWidget {
  const NotifyPreferences({
    Key key,
  }) : super(key: key);

  @override
  _NotifyPreferencesState createState() => _NotifyPreferencesState();
}

class _NotifyPreferencesState extends State<NotifyPreferences> {
  bool notifyMe = false;
  bool notifyRecipient = true;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AddOrderViewModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Notify me by SMS',
                  style: customInputStyle(fontSize: 16),
                ),
                Switch(
                  activeColor: Constant.primaryColor,
                  value: notifyMe,
                  onChanged: (_) {
                    model.notifySenderOnChanged();
                    setState(() {
                      notifyMe = !notifyMe;
                    });
                  },
                ),
              ],
            ),
            const Divider(height: 5, thickness: 1.5),
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

class BottomActionBar extends StatelessWidget {
  final Function callBack;
  const BottomActionBar({Key key, @required this.callBack}) : super(key: key);

  void showPricingDetail(BuildContext context, double distance, double price) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light().copyWith(
            primary: Constant.primaryColor,
          ),
        ),
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Distance"),
                  Text("${distance.round()} KM"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Delivery Fee"),
                  Text("RM ${price.round()}"),
                ],
              ),
            ],
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(_).pop();
              },
              child: const Text('OK'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final price =
        context.select((AddOrderViewModel model) => model.order.price);
    final distance =
        context.select((AddOrderViewModel model) => model.distance);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              showPricingDetail(context, distance, price);
            },
            child: Container(
              child: Row(
                children: [
                  Text(
                    'RM $price ',
                    style: const TextStyle(
                      color: Constant.primaryColor,
                      fontSize: 20.0,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.help_outline, size: 18, color: Colors.grey),
                ],
              ),
            ),
          ),
          Spacer(),
          RaisedButton(
            onPressed: () {
              callBack();
            },
            color: Constant.primaryColor,
            textColor: Colors.white,
            child: Text(
              'CREATE ORDER',
              style: const TextStyle(fontSize: 15.0, letterSpacing: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentSettingSection extends StatelessWidget {
  //final String pickAddress;
  //final List<String> dropAddress;
  const PaymentSettingSection({
    Key key,
    //@required this.pickAddress,
    //@required this.dropAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.local_atm),
                const SizedBox(width: 10),
                Text(
                  'Cash',
                  style: customInputStyle(fontSize: 16.5),
                ),
                const Spacer(),
                const Icon(Icons.check),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        // if (!dropAddress.contains('') && pickAddress != '') ...[
        //   Padding(
        //     padding: const EdgeInsets.only(top: 8.0, left: 25, right: 18),
        //     child: Text(
        //       'Choose payment address',
        //       style: TextStyle(
        //         fontSize: 14,
        //         color: Colors.grey,
        //       ),
        //     ),
        //   ),
        //   RadioListTile(
        //     activeColor: primaryColor,
        //     title: Text(pickAddress),
        //     dense: true,
        //     value: pickAddress,
        //     groupValue: pickAddress,
        //     onChanged: (_) {},
        //   ),
        //   Column(
        //     children: dropAddress
        //         .map(
        //           (m) => RadioListTile(
        //             activeColor: primaryColor,
        //             title: Text(m),
        //             value: m,
        //             dense: true,
        //             groupValue: '123',
        //             onChanged: (_) {},
        //           ),
        //         )
        //         .toList(),
        //   ),
        // ]
      ],
    );
  }
}
