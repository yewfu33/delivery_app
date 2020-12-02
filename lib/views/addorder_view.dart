import 'package:delivery_app/constants.dart';
import 'package:delivery_app/util.dart';
import 'package:delivery_app/view_model/addorder_viewmodel.dart';
import 'package:delivery_app/widgets/CustomInputStyle.dart';
import 'package:delivery_app/widgets/OrderFormValidator.dart';
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
      child: Consumer(
        builder: (BuildContext context, AddOrderViewModel model, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Add New Order'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                iconSize: 27.0,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            bottomNavigationBar:
                BottomActionBar(callBack: () => model.saveOrder()),
            body: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
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
                            VehicleTypePanel(),
                            //name field
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 18),
                              child: TextFormField(
                                validator: nameValidator,
                                onSaved: model.nameFieldOnSave,
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
                                onChanged: (dynamic v) {
                                  model.order.weight = v;
                                },
                              ),
                            ),
                            //pick and drop section
                            PickUpPointPanel(),
                            Divider(
                              height: 20,
                              color: Colors.grey[200],
                              thickness: 20,
                            ),
                            //notify preferences
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 18),
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Notify me by SMS',
                                          style: customInputStyle(fontSize: 16),
                                        ),
                                        Switch(
                                          activeColor: primaryColor,
                                          value: model.order.notifyMebySMS,
                                          onChanged:
                                              model.notifySenderOnChanged,
                                        ),
                                      ],
                                    ),
                                    Divider(height: 5, thickness: 1.5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Notify recipient by SMS',
                                          style: customInputStyle(fontSize: 16),
                                        ),
                                        Switch(
                                          activeColor: primaryColor,
                                          value:
                                              model.order.notifyRecipientbySMS,
                                          onChanged:
                                              model.notifyRecipientOnChanged,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 20,
                              color: Colors.grey[200],
                              thickness: 20,
                            ),
                            //payment section
                            PaymentSettingSection(),
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
      ),
    );
  }
}

class BottomActionBar extends StatelessWidget {
  final Function callBack;
  const BottomActionBar({Key key, @required this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'RM 10',
            style: TextStyle(
              color: primaryColor,
              fontSize: 19.0,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          RaisedButton(
            onPressed: () {
              callBack();
            },
            color: primaryColor,
            textColor: Colors.white,
            child: Text(
              'CREATE ORDER',
              style: TextStyle(fontSize: 15.0, letterSpacing: 0.4),
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
                Icon(Icons.local_atm),
                SizedBox(width: 10),
                Text(
                  'Cash',
                  style: customInputStyle(fontSize: 16.5),
                ),
                Spacer(),
                Icon(Icons.check),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.0),
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
