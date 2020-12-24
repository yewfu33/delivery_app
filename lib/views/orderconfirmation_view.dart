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
      child: Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light().copyWith(
            primary: Constant.primaryColor,
          ),
        ),
        child: AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, route.mainpage, (route) => false);
              },
              child: const Text('OK'),
            )
          ],
        ),
      ),
    ),
  );
}

// get weight info
String setWeightInfo(int weight) {
  switch (weight) {
    case 0:
      return 'Less than 10KG';
      break;
    case 10:
      return 'More than 10KG';
      break;
    case 50:
      return 'More than 50KG';
      break;
    default:
      return 'Less than 10KG';
  }
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
        title: const Text('Order Confirmation'),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar:
          BottomActionBar(callBack: createOrder, order: newOrder),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 24, left: 15, right: 15, bottom: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newOrder.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      setWeightInfo(newOrder.weight.toInt()) +
                          ', ' +
                          setVehicleType(newOrder.vehicleType),
                      style: const TextStyle(fontSize: 15.5),
                    ),
                    const Divider(height: 30, thickness: 1.5),
                    Text(
                      'Pick-up point',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Constant.primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.explore,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              newOrder.address,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: const TextStyle(fontSize: 15.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                                DateFormat('dd MMM yyyy h:mm a')
                                    .format(newOrder.dateTime),
                                style: const TextStyle(fontSize: 15.5)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.contact_phone,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text('+60${newOrder.contact}',
                                style: const TextStyle(fontSize: 15.5)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.comment,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              newOrder.comment,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: const TextStyle(fontSize: 15.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 30, thickness: 1.5),
                    Text(
                      'Drop-off point${(newOrder.dropPoint.length > 1) ? 's' : ''} (${newOrder.dropPoint.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Constant.primaryColor,
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: newOrder.dropPoint.length,
                      itemBuilder: (_, i) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.explore,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      newOrder.dropPoint[i].address,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: const TextStyle(fontSize: 15.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                        DateFormat('dd MMM yyyy h:mm a').format(
                                            newOrder.dropPoint[i].dateTime),
                                        style: const TextStyle(fontSize: 15.5)),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.contact_phone,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                        '+60${newOrder.dropPoint[i].contact}',
                                        style: const TextStyle(fontSize: 15.5)),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.comment,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      newOrder.dropPoint[i].comment,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: const TextStyle(fontSize: 15.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (_, __) {
                        return const Divider(height: 20, thickness: 1.5);
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
            'RM ${widget.order.price}',
            style: const TextStyle(
              color: Constant.primaryColor,
              fontSize: 19.0,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (isLoading)
            FlatButton(
              onPressed: () {},
              child: const CircularProgressIndicator(
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
              child: const Text(
                'CREATE ORDER',
                style: const TextStyle(fontSize: 15.0, letterSpacing: 0.4),
              ),
            ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 5,
            offset: Offset(0, -1.5), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
