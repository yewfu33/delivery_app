import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/order.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:delivery_app/routes_name.dart' as route;

import '../util.dart';

void showOrderCreatedDialog(
    BuildContext context, String title, String content) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, route.mainpage, (route) => false);
            },
            child: Text('OK'),
          )
        ],
      ),
    ),
  );
}

class OrderConfirmationPage extends StatelessWidget {
  final Order newOrder;
  final Future<bool> Function(Order) createOrder;

  const OrderConfirmationPage(
      {Key key, @required this.newOrder, @required this.createOrder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar:
          BottomActionBar(callBack: createOrder, order: newOrder),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding:
                    EdgeInsets.only(top: 24, left: 15, right: 15, bottom: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newOrder.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Less than 10KG, ' + setVehicleType(newOrder.vehicleType),
                      style: TextStyle(fontSize: 15.5),
                    ),
                    Divider(height: 30, thickness: 1.5),
                    Text(
                      'Pick-up point',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Constant.primaryColor,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(newOrder.address,
                              style: TextStyle(fontSize: 15.5)),
                          SizedBox(height: 10),
                          Text(
                              DateFormat('dd MMM yyyy h:mm a')
                                  .format(newOrder.dateTime),
                              style: TextStyle(fontSize: 15.5)),
                          SizedBox(height: 10),
                          Text('+60 ${newOrder.contact}',
                              style: TextStyle(fontSize: 15.5)),
                          SizedBox(height: 10),
                          Text(newOrder.comment,
                              style: TextStyle(fontSize: 15.5)),
                        ],
                      ),
                    ),
                    Divider(height: 30, thickness: 1.5),
                    Text(
                      'Drop-off point${(newOrder.dropPoint.length > 1) ? 's' : ''} (${newOrder.dropPoint.length})',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Constant.primaryColor,
                      ),
                    ),
                    SizedBox(height: 15),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: newOrder.dropPoint.length,
                      itemBuilder: (_, i) {
                        return Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(newOrder.dropPoint[i].address,
                                  style: TextStyle(fontSize: 15.5)),
                              SizedBox(height: 10),
                              Text(
                                  DateFormat('dd MMM yyyy h:mm a')
                                      .format(newOrder.dropPoint[i].dateTime),
                                  style: TextStyle(fontSize: 15.5)),
                              SizedBox(height: 10),
                              Text('+60 ${newOrder.dropPoint[i].contact}',
                                  style: TextStyle(fontSize: 15.5)),
                              SizedBox(height: 10),
                              Text(newOrder.dropPoint[i].comment,
                                  style: TextStyle(fontSize: 15.5)),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (_, __) {
                        return Divider(height: 20, thickness: 1.5);
                      },
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomActionBar extends StatefulWidget {
  final Future<bool> Function(Order) callBack;
  final Order order;
  const BottomActionBar(
      {Key key, @required this.callBack, @required this.order})
      : super(key: key);

  @override
  _BottomActionBarState createState() => _BottomActionBarState();
}

class _BottomActionBarState extends State<BottomActionBar> {
  bool isLoading = false;

  void setLoadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

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
              color: Constant.primaryColor,
              fontSize: 19.0,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (isLoading)
            FlatButton(
              onPressed: () {},
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Constant.primaryColor)),
            )
          else
            RaisedButton(
              onPressed: () async {
                setLoadingState(true);
                bool v = await widget.callBack(widget.order);
                if (v) {
                  setLoadingState(false);

                  showOrderCreatedDialog(context, 'Order successfully created',
                      'Your will receive notification when couriers take your order');
                } else {
                  setLoadingState(false);
                  print('error in create order');
                  showOrderCreatedDialog(
                      context, 'Error occured', 'Please try again later');
                }
              },
              color: Constant.primaryColor,
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
