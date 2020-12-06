import 'package:delivery_app/constants.dart';
import 'package:delivery_app/wrappers/loading_dialog.dart';
import 'package:flutter/material.dart';

class LoadingViewWrapper extends StatefulWidget {
  final Widget child;
  const LoadingViewWrapper({Key key, this.child}) : super(key: key);
  @override
  _LoadingViewWrapperState createState() => _LoadingViewWrapperState();
}

class _LoadingViewWrapperState extends State<LoadingViewWrapper> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Constant.primaryColor),
      builder: (_, widget) => Navigator(
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => LoadingDialog(child: widget),
        ),
      ),
      home: widget.child,
    );
  }
}
