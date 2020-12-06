import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/uiModels/order_model.dart';
import 'package:delivery_app/util.dart';
import 'package:delivery_app/view_model/activeorder_viewmodel.dart';
import 'package:delivery_app/views/orderdetail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import 'package:intl/intl.dart';

class ActiveOrder extends StatefulWidget {
  @override
  _ActiveOrderState createState() => _ActiveOrderState();
}

class _ActiveOrderState extends State<ActiveOrder> {
  int _count = 0;
  List<OrderModel> _orders;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ActiveOrderViewModel>(
      create: (_) => ActiveOrderViewModel(),
      builder: (context, _) {
        final model = context.watch<ActiveOrderViewModel>();

        return EasyRefresh.custom(
          header: DeliveryHeader(
            backgroundColor: Colors.grey[100],
          ),
          firstRefresh: true,
          firstRefreshWidget: Container(
            child: Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Constant.primaryColor)),
            ),
          ),
          onRefresh: () async {
            _orders = await model.fetchActiveOrder();
            if (_orders == null) return;

            if (mounted) {
              setState(() {
                _count = _orders.length;
              });
            }
          },
          onLoad: null,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Column(
                    children: [
                      ActiveOrderList(order: _orders[index]),
                    ],
                  );
                },
                childCount: _count,
              ),
            ),
          ],
          emptyWidget: (_orders == null || _orders.length == 0)
              ? Container(
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(),
                        flex: 2,
                      ),
                      SizedBox(
                        width: 50.0,
                        height: 60.0,
                        child: Icon(
                          Icons.assignment,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                      Text(
                        'No active orders at the moment',
                        style:
                            TextStyle(fontSize: 14.0, color: Colors.grey[400]),
                      ),
                      Expanded(
                        child: SizedBox(),
                        flex: 3,
                      ),
                    ],
                  ),
                )
              : null,
        );
      },
    );
  }
}

class ActiveOrderList extends StatelessWidget {
  final OrderModel order;
  // final DateFormat dateFormat = DateFormat('dd MM yyyy | jmz');
  ActiveOrderList({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      closedBuilder: (context, action) => Container(
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
                'RM 10',
                style: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 5),
              //   child: Text(
              //     order.address,
              //     maxLines: 2,
              //     overflow: TextOverflow.ellipsis,
              //     softWrap: true,
              //     style: GoogleFonts.roboto(fontSize: 14),
              //   ),
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
      openBuilder: (context, action) {
        return OrderDetailView(o: order);
      },
    );
  }
}
