import 'dart:convert';

import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/uiModels/order_model.dart';
import 'package:delivery_app/pages/MapPage.dart';
import 'package:delivery_app/services/order_service.dart';
import 'package:delivery_app/util.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailView extends StatefulWidget {
  final OrderModel o;

  OrderDetailView({Key key, @required this.o}) : super(key: key);

  @override
  _OrderDetailViewState createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  final OrderService orderService = OrderService();
  Flushbar flush;

  // get weight info
  String setWeightInfo(int weight) {
    switch (weight) {
      case 0:
        return '< 10';
        break;
      case 10:
        return '> 10';
        break;
      case 50:
        return '> 50';
        break;
      default:
        return '< 10>';
    }
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget.o.status == 1) {
        flush = Flushbar(
          message: "The courier has started the delivery order",
          animationDuration: const Duration(milliseconds: 500),
          mainButton: FlatButton(
            onPressed: () {
              flush.dismiss(); // dismiss the flushbar
              // navigate to order tracking page
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => MapPage(order: widget.o)));
            },
            child: const Text(
              "Track Order",
              style: const TextStyle(color: Constant.primaryColor),
            ),
          ),
        )..show(context);
      }
    });
  }

  Future cancelOrder(BuildContext context) async {
    try {
      var res = await orderService.cancelOrder(widget.o.orderId);

      if (res == null) {
        showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.5),
          builder: (_) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Try again later"),
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
      } else {
        if (res.statusCode == 200) {
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black.withOpacity(0.5),
            builder: (_) {
              return WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  title: Text("Message"),
                  content: Text("You have cancelled the delivery order"),
                  actions: [
                    FlatButton(
                      child: Text("OK",
                          style: const TextStyle(color: Constant.primaryColor)),
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, "/", (_) => false),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          var resbody = json.decode(res.body);
          showDialog(
            context: context,
            barrierDismissible: true,
            barrierColor: Colors.black.withOpacity(0.5),
            builder: (_) {
              return AlertDialog(
                title: Text("Error"),
                content: Text(resbody["message"]),
                actions: [
                  FlatButton(
                    child: Text("OK",
                        style: const TextStyle(color: Constant.primaryColor)),
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, "/", (_) => false),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> showConfirmationDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) {
        return AlertDialog(
          title: Text("Confimation"),
          content: Text("Are you sure to cancel the order?"),
          actions: [
            FlatButton(
              child: Text("CANCEL",
                  style: const TextStyle(color: Constant.primaryColor)),
              onPressed: () => Navigator.pop(_, false),
            ),
            FlatButton(
              child: Text("OK",
                  style: const TextStyle(color: Constant.primaryColor)),
              onPressed: () => Navigator.pop(_, true),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order ${widget.o.orderId}'),
        leading: const BackButton(),
        actions: [
          if (widget.o.status == 0)
            FlatButton(
              onPressed: () async {
                var confirmation = await showConfirmationDialog(context);
                if (confirmation != null) {
                  if (confirmation) {
                    cancelOrder(context);
                  }
                }
              },
              child: const Text("Cancel"),
              textColor: Colors.white,
            )
        ],
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Container(
          width: double.infinity,
          child: ScrollConfiguration(
            behavior: MyScrollBehavior(),
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 13, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 15),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'RM ${widget.o.price}',
                                  style: GoogleFonts.firaSans(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                setOrderStatus(widget.o.status),
                                style: GoogleFonts.firaSans(
                                  color: Constant.primaryColor,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 17),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Icon(Icons.explore),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  widget.o.address,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: GoogleFonts.roboto(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const DetailViewDivider(),
                    //Courier Info
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          top: 5, bottom: 10, left: 13, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Courier',
                            style: GoogleFonts.cabin(
                              color: Constant.primaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 25.0),
                                child: CircleAvatar(
                                  backgroundColor: Constant.primaryColor,
                                  radius: 27,
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: widget.o.courier
                                                ?.profilePic?.isEmpty ??
                                            true
                                        ? AssetImage('assets/img/avatar.jpg')
                                        : NetworkImage(Constant.serverName +
                                            Constant.imagePath +
                                            widget.o.courier.profilePic),
                                  ),
                                ),
                              ),
                              Text(
                                widget.o.courier?.name ??
                                    'No courier assigned yet',
                                style: GoogleFonts.cabin(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const DetailViewDivider(),
                    // order detail
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          top: 5, bottom: 10, left: 13, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Details',
                            style: GoogleFonts.cabin(
                              color: Constant.primaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Table(
                            //   border: TableBorder.all(),
                            children: [
                              // Content
                              TableRow(
                                children: [
                                  DetailTitleCell(title: 'Content'),
                                  DetailPropertiesCell(title: widget.o.name),
                                ],
                              ),
                              // Delivery type
                              TableRow(
                                children: [
                                  DetailTitleCell(title: 'Delivery Type'),
                                  DetailPropertiesCell(
                                      title:
                                          setVehicleType(widget.o.vehicleType)),
                                ],
                              ),
                              // Weight
                              TableRow(
                                children: [
                                  DetailTitleCell(title: 'Weight (KG)'),
                                  DetailPropertiesCell(
                                      title:
                                          '${setWeightInfo(widget.o.weight.toInt())}'),
                                ],
                              ),
                              // Payment Method
                              TableRow(
                                children: [
                                  DetailTitleCell(title: 'Payment Method'),
                                  DetailPropertiesCell(title: 'Cash'),
                                ],
                              ),
                              // Created At
                              TableRow(
                                children: [
                                  DetailTitleCell(title: 'Created At'),
                                  DetailPropertiesCell(
                                      title: DateFormat('dd MMM yyyy h:mm a')
                                          .format(widget.o.dateTime)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const DetailViewDivider(),
                    DeliveryPoint(order: widget.o),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DetailViewDivider extends StatelessWidget {
  const DetailViewDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: const Divider(color: Colors.black),
    );
  }
}

class ActionButton extends StatelessWidget {
  final text;
  final Function function;
  final Color color;

  const ActionButton(
      {Key key,
      @required this.text,
      @required this.function,
      @required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        function();
      },
      color: color,
      textColor: Colors.white,
      child: Text(text, style: TextStyle(fontSize: 15, letterSpacing: 0.5)),
    );
  }
}

class DetailTitleCell extends StatelessWidget {
  final String title;

  const DetailTitleCell({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            title,
            style: GoogleFonts.cabin(
              fontSize: 15,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          )),
    );
  }
}

class DetailPropertiesCell extends StatelessWidget {
  final String title;

  const DetailPropertiesCell({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            title,
            style: GoogleFonts.sourceSansPro(fontSize: 15),
          )),
    );
  }
}

class DeliveryPoint extends StatefulWidget {
  final OrderModel order;

  const DeliveryPoint({Key key, @required this.order}) : super(key: key);

  @override
  _DeliveryPointState createState() => _DeliveryPointState();
}

class _DeliveryPointState extends State<DeliveryPoint> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stepper(
        physics: NeverScrollableScrollPhysics(),
        controlsBuilder: (BuildContext context,
                {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
            Container(),
        steps: [
          Step(
            isActive: true,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    widget.order.address,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            content: StepContent(
                date: widget.order.dateTime,
                contact: widget.order.contact,
                remark: widget.order.comment),
            state: StepState.indexed,
          ),
          ...widget.order.dropPoint.map((d) {
            return Step(
              isActive: true,
              title: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      d.address,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              content: StepContent(
                date: d.dateTime,
                contact: d.contact,
                remark: d.comment,
              ),
              state: StepState.indexed,
            );
          }).toList(),
        ],
        currentStep: _index,
        onStepTapped: (int i) {
          setState(() => _index = i);
        },
      ),
    );
  }
}

class StepContent extends StatelessWidget {
  final DateTime date;
  final String contact;
  final String remark;

  const StepContent({
    Key key,
    @required this.date,
    @required this.contact,
    @required this.remark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepContentProperties(
              title: 'Delivery Datetime',
              property: DateFormat('dd MMM yyyy h:mm a').format(date)),
          const SizedBox(height: 13),
          StepContentProperties(title: 'Contact', property: '+60$contact'),
          const SizedBox(height: 13),
          StepContentProperties(title: 'Remark', property: remark),
        ],
      ),
    );
  }
}

class StepContentProperties extends StatelessWidget {
  final String title;
  final String property;

  const StepContentProperties({
    Key key,
    @required this.title,
    @required this.property,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.cabin(
              fontSize: 15,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text((property.isEmpty) ? "-" : property,
              softWrap: true,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.sourceSansPro(fontSize: 15)),
        ],
      ),
    );
  }
}
