import 'package:delivery_app/models/uiModels/order_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:delivery_app/routes_name.dart' as route;
import '../constants.dart';
import '../util.dart';

class OrderList extends StatelessWidget {
  final OrderModel order;
  // final DateFormat dateFormat = DateFormat('dd MM yyyy | jmz');
  OrderList({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route.orderDetailPage, arguments: order);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 19, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '#${order.orderId.toString()}',
                  style:
                      GoogleFonts.barlow(fontSize: 14, color: Colors.grey[500]),
                ),
                Text(
                  setOrderStatus(order.status),
                  style: GoogleFonts.firaSans(
                    fontSize: 16,
                    color: Constant.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 7),
              child: Text(
                'RM ${order.price.round()}',
                style: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(Icons.explore),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      order.address,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: GoogleFonts.roboto(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              DateFormat('MMM dd - h:mm a').format(order.dateTime),
              style: GoogleFonts.barlow(
                fontSize: 13.7,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.black.withOpacity(0.45),
              width: 0.65,
            ),
          ),
        ),
      ),
    );
  }
}
