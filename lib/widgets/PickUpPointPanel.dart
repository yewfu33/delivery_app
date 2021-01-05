import 'package:delivery_app/constants.dart';
import 'package:delivery_app/util.dart';
import 'package:delivery_app/view_model/addorder_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

import 'package:intl/intl.dart';
import 'package:flutter_config/flutter_config.dart';

import 'MyInputDecoration.dart';

class RemoveAddressButton extends StatelessWidget {
  final Function voidCallBack;

  const RemoveAddressButton({
    Key key,
    this.voidCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Spacer(),
        FlatButton(
            onPressed: () => voidCallBack(),
            child: Row(
              children: const [
                Icon(Icons.delete_sweep, color: Constant.primaryColor),
                SizedBox(width: 1.5),
                Text(
                  'Remove address',
                  style: TextStyle(
                    letterSpacing: 0.4,
                    fontSize: 14,
                    color: Constant.primaryColor,
                  ),
                ),
              ],
            )),
      ],
    );
  }
}

class PickedLocation {
  String address;
  double latitude;
  double longtitude;
}

Future<PickedLocation> showPlacePicker(BuildContext context) async {
  /// initialize display a location
  const LatLng displayLocation = LatLng(1.550049, 103.5928664);

  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PlacePicker(
        apiKey: FlutterConfig.get('GOOGLE_MAPS_API_KEY') as String,
        enableMapTypeButton: false,
        region: "MY",
        autoCompleteDebounceInMilliseconds: 1000,
        cameraMoveDebounceInMilliseconds: 1000,
        hintText: 'Search places here...',
        initialPosition: displayLocation,
        useCurrentLocation: true,
        onPlacePicked: (result) {
          //   print(result.geometry.location.lat);
          //   print(result.geometry.location.lng);

          final pickedLocation = PickedLocation()
            ..address = result.formattedAddress
            ..latitude = result.geometry.location.lat
            ..longtitude = result.geometry.location.lng;

          // pop back screen with data
          Navigator.pop(context, pickedLocation);
        },
      ),
    ),
  );

  return result as PickedLocation;
}

Step dropOffPoint(BuildContext context, AddOrderViewModel model, int index) {
  return Step(
    isActive: true,
    title: const Text('Drop-off point', style: TextStyle(fontSize: 17)),
    content: Container(
      padding: EdgeInsets.zero,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: model.order.dropPoint[index].addressFieldController,
            validator: (v) {
              if (v.trim().isEmpty) {
                return 'This field is required';
              } else {
                return null;
              }
            },
            maxLines: null,
            readOnly: true,
            onSaved: (String value) {
              model.order.dropPoint[index].address = value;
            },
            onTap: () async {
              final p = await showPlacePicker(context);
              if (p == null) return;

              model.order.dropPoint[index].latitude = p.latitude;
              model.order.dropPoint[index].longitude = p.longtitude;

              model.order.dropPoint[index].addressFieldController.text =
                  p.address;

              model.order.dropPoint[index].address = p.address;

              model.addressesFieldOnChanged(context);
            },
            decoration: InputDecoration(
              hintText: 'Address',
              suffixIcon: const Icon(Icons.gps_fixed),
              suffixIconConstraints: const BoxConstraints.tightFor(),
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              hintStyle: customInputStyle(),
            ),
          ),
          const SizedBox(height: 13),
          TextFormField(
            initialValue: "+60 ",
            validator: (v) {
              if (v == '+60 ') {
                return 'This field is required';
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.phone,
            onSaved: (String value) {
              model.order.dropPoint[index].contact = value.substring(4);
            },
            inputFormatters: [CustomPhoneNumberFormatter()],
            decoration: const InputDecoration(
              labelText: 'Contact number',
              suffixIcon: Icon(Icons.contact_phone),
              suffixIconConstraints: BoxConstraints.tightFor(),
              contentPadding: EdgeInsets.symmetric(),
            ),
          ),
          const SizedBox(height: 13),
          TextFormField(
            controller: model.order.dropPoint[index].dateTimeFieldController,
            validator: (v) {
              if (v.trim().isEmpty) {
                return 'This field is required';
              } else {
                return null;
              }
            },
            readOnly: true,
            onTap: () async {
              final date = await openDatePicker(context);
              if (date == null) return;
              final time = await openTimePicker(context);
              if (time == null) return;

              final dt = DateTime(
                  date.year, date.month, date.day, time.hour, time.minute);

              model.order.dropPoint[index].dateTimeFieldController.text =
                  DateFormat('dd MMM yyyy h:mm a').format(dt);

              model.order.dropPoint[index].dateTime = dt;
            },
            decoration: InputDecoration(
              hintText: 'When to arrive this address',
              labelText: 'When to arrive this address',
              contentPadding: const EdgeInsets.symmetric(),
              hintStyle: customInputStyle(),
              labelStyle: customInputStyle(),
            ),
          ),
          const SizedBox(height: 13),
          TextFormField(
            maxLines: null,
            onSaved: (String value) {
              model.order.dropPoint[index].comment = value;
            },
            decoration: InputDecoration(
              hintText: 'Remark',
              contentPadding: const EdgeInsets.symmetric(),
              hintStyle: customInputStyle(),
            ),
          ),
          if (model.order.dropPoint.length == (index + 1) &&
              model.order.dropPoint.length > 1)
            RemoveAddressButton(voidCallBack: () {
              model.removeLastDropPoint();
              model.addressesFieldOnChanged(context);
            })
          else
            const SizedBox.shrink(),
        ],
      ),
    ),
  );
}

Future<DateTime> openDatePicker(BuildContext context) {
  return showDatePicker(
    context: context,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 10)),
    initialDate: DateTime.now(),
    builder: (_, Widget child) {
      return Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light()
              .copyWith(primary: Constant.primaryColor),
        ),
        child: child,
      );
    },
  );
}

Future<TimeOfDay> openTimePicker(BuildContext context) {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (_, Widget child) {
      return Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light()
              .copyWith(primary: Constant.primaryColor),
        ),
        child: child,
      );
    },
  );
}

class PickUpPointPanel extends StatefulWidget {
  const PickUpPointPanel({
    Key key,
  }) : super(key: key);

  @override
  _PickUpPointPanelState createState() => _PickUpPointPanelState();
}

class _PickUpPointPanelState extends State<PickUpPointPanel> {
  int _index = 0;

  TextEditingController _addressFieldController;
  TextEditingController _dateTimeFieldController;

  @override
  void initState() {
    super.initState();
    _addressFieldController = TextEditingController();
    _dateTimeFieldController = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _addressFieldController.dispose();
    _dateTimeFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AddOrderViewModel model = Provider.of<AddOrderViewModel>(context);

    return Column(
      children: [
        Stepper(
          physics: const NeverScrollableScrollPhysics(),
          currentStep: _index,
          onStepTapped: (int i) => setState(() => _index = i),
          controlsBuilder: (_,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
              Container(),
          steps: [
            Step(
              isActive: true,
              title:
                  const Text('Pick-up point', style: TextStyle(fontSize: 17)),
              content: Container(
                padding: EdgeInsets.zero,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _addressFieldController,
                      validator: (v) {
                        if (v.trim().isEmpty) {
                          return 'This field is required';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (v) {
                        model.order.address = v;
                      },
                      readOnly: true,
                      maxLines: null,
                      onTap: () async {
                        final p = await showPlacePicker(context);
                        if (p == null) return;

                        model.order.latitude = p.latitude;
                        model.order.longitude = p.longtitude;

                        _addressFieldController.text = p.address;

                        model.order.address = p.address;

                        model.addressesFieldOnChanged(context);
                      },
                      decoration: InputDecoration(
                        hintText: 'Address',
                        suffixIcon: const Icon(Icons.gps_fixed),
                        suffixIconConstraints: const BoxConstraints.tightFor(),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        hintStyle: customInputStyle(),
                      ),
                    ),
                    const SizedBox(height: 13),
                    TextFormField(
                      initialValue: "+60 ",
                      validator: (v) {
                        if (v == '+60 ') {
                          return 'This field is required';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (v) {
                        model.order.contact = v.substring(4);
                      },
                      keyboardType: TextInputType.phone,
                      inputFormatters: [CustomPhoneNumberFormatter()],
                      decoration: const InputDecoration(
                        labelText: 'Contact number',
                        suffixIcon: Icon(Icons.contact_phone),
                        suffixIconConstraints: BoxConstraints.tightFor(),
                        contentPadding: EdgeInsets.symmetric(),
                      ),
                    ),
                    const SizedBox(height: 13),
                    TextFormField(
                      controller: _dateTimeFieldController,
                      validator: (v) {
                        if (v.trim().isEmpty) {
                          return 'This field is required';
                        } else {
                          return null;
                        }
                      },
                      readOnly: true,
                      onTap: () async {
                        final date = await openDatePicker(context);
                        if (date == null) return;
                        final time = await openTimePicker(context);
                        if (time == null) return;

                        final dt = DateTime(date.year, date.month, date.day,
                            time.hour, time.minute);

                        _dateTimeFieldController.text =
                            DateFormat('dd MMM yyyy h:mm a').format(dt);
                        // save the date
                        model.order.dateTime = dt;
                      },
                      decoration: InputDecoration(
                        labelText: 'When to arrive this address',
                        hintText: 'When to arrive this address',
                        contentPadding: const EdgeInsets.symmetric(),
                        hintStyle: customInputStyle(),
                        labelStyle: customInputStyle(),
                      ),
                    ),
                    const SizedBox(height: 13),
                    TextFormField(
                      onSaved: (v) {
                        model.order.comment = v;
                      },
                      decoration: InputDecoration(
                        hintText: 'Remark',
                        contentPadding: const EdgeInsets.symmetric(),
                        hintStyle: customInputStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            for (var i = 0; i < model.order.dropPoint.length; i++)
              dropOffPoint(context, model, i)
          ],
        ),
        Align(
          child: FlatButton(
            onPressed: () => model.addDropPoint(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add_location, color: Constant.primaryColor),
                SizedBox(width: 1.5),
                Text(
                  'Add more delivery point',
                  style: TextStyle(
                    color: Constant.primaryColor,
                    fontSize: 15,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
