import 'package:flutter/material.dart';
import 'package:flutter_app/providers/orders.dart';
import 'package:flutter_app/widget/app_drawer.dart';
import 'package:flutter_app/widget/order_item.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/OrderScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders')),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: FlutterLogo(size: 100));
          } else {
            if (snapshot.error != null)
              return Center(child: Text('An error occurred!'));
            else
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (context, index) =>
                      OrderItem(orderData.orders[index]),
                ),
              );
          }
        },
      ),
    );
  }
}
