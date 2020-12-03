import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/providers/cart.dart';
import 'package:flutter_app/providers/orders.dart';
import 'package:flutter_app/providers/product.dart';
import 'package:flutter_app/providers/products.dart';
import 'package:flutter_app/screen/cart_screen.dart';
import 'package:flutter_app/screen/edit_screen.dart';
import 'package:flutter_app/screen/oredrs_screen.dart';
import 'package:flutter_app/screen/product_detail_screen.dart';
import 'package:flutter_app/screen/product_overview_screen.dart';
import 'package:flutter_app/screen/splash_screen.dart';
import 'package:flutter_app/screen/user_product_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: AuthProvider()),
      ChangeNotifierProvider.value(value: CartProvider()),
      ChangeNotifierProvider.value(value: OrdersProvider()),
      ChangeNotifierProvider.value(value: ProductProvider()),
      ChangeNotifierProvider.value(value: ProductsProvider()),
    ],
    builder: (context, child) => MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        accentColor: Colors.pinkAccent,
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      initialRoute: ProductOverviewScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        ProductOverviewScreen.routeName: (context) => ProductOverviewScreen(),
        ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
        CardScreen.routeName: (context) => CardScreen(),
        OrderScreen.routeName: (context) => OrderScreen(),
        UserProductScreen.routeName: (context) => UserProductScreen(),
        EditScreen.routeName: (context) => EditScreen(),
      },
    );
  }
}
