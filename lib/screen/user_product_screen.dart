import 'package:flutter/material.dart';
import 'package:flutter_app/widget/app_drawer.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/UserProductScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shop')),
      body: Center(child: Text('Text'),),
      drawer: AppDrawer(),
    );
  }
}