import 'package:flutter/material.dart';
import 'package:flutter_app/widget/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/OrderScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shop')),
      body: Center(child: Text('Text'),),
      drawer: AppDrawer(),
    );
  }
}