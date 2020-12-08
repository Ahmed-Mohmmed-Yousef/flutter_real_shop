import 'package:flutter/material.dart';
import 'package:flutter_app/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  final OrderItemModel orderItem;
  const OrderItem(this.orderItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text('\$${orderItem.amount}'),
        subtitle:
            Text(DateFormat('dd/MM/yyyy/ hh:mm').format(orderItem.dateTime)),
        children: orderItem.products
            .map((product) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${product.quntity} X \$${product.price}',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
