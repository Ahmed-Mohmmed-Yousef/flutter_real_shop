import 'package:flutter/material.dart';

class CardScreen extends StatelessWidget {
  static const routeName = '/CardScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CardScreen')),
      body: Center(child: Text('CardScreen'),),
    );
  }
}