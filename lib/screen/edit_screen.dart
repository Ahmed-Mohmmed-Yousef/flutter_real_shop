import 'package:flutter/material.dart';

class EditScreen extends StatelessWidget {
  static const routeName = '/EditScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shop')),
      body: Center(child: Text('Text'),),
    );
  }
}