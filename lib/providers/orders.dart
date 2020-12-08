import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/providers/cart.dart';

class OrderItemModel {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItemModel({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItemModel> _orders = [];
  String authToken;
  String userId;

  getData(String token, String uid, List<OrderItemModel> orders) {
    authToken = token;
    userId = uid;
    _orders = orders;
    notifyListeners();
  }

  List<OrderItemModel> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    print('fetchAndSetOrders gooo');
    final url =
        'https://whatsapp-83586.firebaseio.com/real_shop/orders/$userId.json?auth=$authToken';

    try {
      print('try gooo');
      final res = await http.get(url);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        print('extractedData null');
        return;
      }
      final List<OrderItemModel> loadedOrders = [];
      extractedData.forEach((key, value) {
        loadedOrders.add(
          OrderItemModel(
            id: key,
            amount: value['amount'],
            products: (value['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quntity: item['quantity'],
                    price: item['price'],
                  ),
                )
                .toList(),
            dateTime: DateTime.parse(value['dateTime']),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      print('_orders to loaded ${_orders.length}');
      notifyListeners();
    } catch (e) {
      print('catch ${e.toString()}');
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartroducts, double total) async {
    final url =
        'https://whatsapp-83586.firebaseio.com/real_shop/orders/$userId.json?auth=$authToken';
    try {
      final timeStamp = DateTime.now();
      final res = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartroducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quntity,
                    'price': cp.price,
                  })
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderItemModel(
          id: json.decode(res.body)['name'],
          amount: total,
          products: cartroducts,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
