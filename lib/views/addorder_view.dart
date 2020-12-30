import 'package:delivery_app/util.dart';
import 'package:delivery_app/view_model/addorder_viewmodel.dart';
import 'package:delivery_app/widgets/BottomActionBar.dart';
import 'package:delivery_app/widgets/MyInputDecoration.dart';
import 'package:delivery_app/widgets/NotifyPreferences.dart';
import 'package:delivery_app/widgets/PaymentSettingSection.dart';
import 'package:delivery_app/widgets/PickUpPointPanel.dart';
import 'package:delivery_app/widgets/PromoCodeSection.dart';
import 'package:delivery_app/widgets/VehicleTypePanel.dart';
import 'package:delivery_app/widgets/WeightField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddOrderView extends StatelessWidget {
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
                              style: const TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                labelText: 'What are you sending?',
                                contentPadding: EdgeInsets.zero,
                                labelStyle: customInputStyle(),
                              ),
                            ),
                          ),
                          //weight field
                          WeightField(model: model),
                          //pick and drop section
                          const PickUpPointPanel(),
                          Divider(
                            height: 20,
                            color: Colors.grey[200],
                            thickness: 20,
                          ),
                          const PromoCodeSection(),
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
