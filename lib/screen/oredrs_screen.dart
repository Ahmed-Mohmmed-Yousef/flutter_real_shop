import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/OrderScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shop')),
      body: Center(child: Text('Text'),),
    );
  }
}