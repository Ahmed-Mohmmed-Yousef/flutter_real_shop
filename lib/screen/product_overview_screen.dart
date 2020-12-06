import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/widget/app_drawer.dart';
import 'package:provider/provider.dart';

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/ProductOverviewScreen';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shop')),
      body: Center(
        child: Text('Text'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<AuthProvider>(context, listen: false).logout();
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
