import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/uiModels/order_model.dart';
import 'package:delivery_app/util.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailView extends StatelessWidget {
  final OrderModel o;

  OrderDetailView({Key key, @required this.o}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order ${o.orderId}'),
        leading: BackButton(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.mode_edit),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: Stack(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Container(
              width: double.infinity,
              child: ScrollConfiguration(
                behavior: MyScrollBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 19),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 13, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text('RM 10',
                                            style: TextStyle(
                                              fontSize: 23.4,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ),
                                      Text(
                                        setOrderStatus(o.status),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(Icons.explore),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          o.address,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 25.0),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Constant.primaryColor,
                                          radius: 27,
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                                'https://www.bhg.com.au/media/23359/red-blue-black-bedroom.jpg?width=720&center=0.0,0.0'),
                                          ),
                                        ),
                                      ),
                                      Text('Courier name here',
                                          style: GoogleFonts.cabin(
                                            fontSize: 16,
                                          )),
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
                                          DetailPropertiesCell(title: o.name),
                                        ],
                                      ),
                                      // Delivery type
                                      TableRow(
                                        children: [
                                          DetailTitleCell(
                                              title: 'Delivery Type'),
                                          DetailPropertiesCell(
                                              title: setVehicleType(
                                                  o.vehicleType)),
                                        ],
                                      ),
                                      // Weight
                                      TableRow(
                                        children: [
                                          DetailTitleCell(title: 'Weight (KG)'),
                                          DetailPropertiesCell(
                                              title: '${o.weight.ceil()}'),
                                        ],
                                      ),
                                      // Payment Method
                                      TableRow(
                                        children: [
                                          DetailTitleCell(
                                              title: 'Payment Method'),
                                          DetailPropertiesCell(title: 'Cash'),
                                        ],
                                      ),
                                      // Created At
                                      TableRow(
                                        children: [
                                          DetailTitleCell(title: 'Created At'),
                                          DetailPropertiesCell(
                                              title: DateFormat(
                                                      'dd MMM yyyy h:mm a')
                                                  .format(o.dateTime)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const DetailViewDivider(),
                            DeliveryPoint(order: o),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              margin: EdgeInsets.zero,
              child: SizedBox(
                width: double.infinity,
                child: ActionButton(
                  text: 'Track Order'.toUpperCase(),
                  function: () {},
                  color: Constant.primaryColor,
                ),
              ),
            ),
          ),
        ],
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
          const SizedBox(height: 15),
          StepContentProperties(title: 'Contact', property: '+60 $contact'),
          const SizedBox(height: 15),
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
          Text(property, style: GoogleFonts.sourceSansPro(fontSize: 15)),
        ],
      ),
    );
  }
}
