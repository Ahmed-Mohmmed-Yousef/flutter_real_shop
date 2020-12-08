import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/providers/cart.dart';
import 'package:flutter_app/providers/orders.dart';
import 'package:flutter_app/providers/product.dart';
import 'package:flutter_app/providers/products.dart';
import 'package:flutter_app/screen/auth_screen.dart';
import 'package:flutter_app/screen/cart_screen.dart';
import 'package:flutter_app/screen/edit_screen.dart';
import 'package:flutter_app/screen/oredrs_screen.dart';
import 'package:flutter_app/screen/product_detail_screen.dart';
import 'package:flutter_app/screen/product_overview_screen.dart';
import 'package:flutter_app/screen/splash_screen.dart';
import 'package:flutter_app/screen/user_product_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main()  {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: AuthProvider()),
      ChangeNotifierProxyProvider<AuthProvider, Products>(
        create: (_) => Products(),
        update: (ctx, authValue, previousProducts) => previousProducts..getData(
          authValue.token,
          authValue.userId,
          previousProducts == null ? null : previousProducts.items,
        ),
      ),
      ChangeNotifierProvider.value(value: Cart()),
      ChangeNotifierProxyProvider<AuthProvider, Orders>(
        create: (_) => Orders(),
        update: (ctx, authValue, previousOrders) => previousOrders..getData(
          authValue.token,
          authValue.userId,
          previousOrders.orders ?? [],
        ),
      ),
      // ChangeNotifierProvider.value(value: Product()),
    ],
    builder: (context, child) => MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (ctx, auth, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.teal,
          accentColor: Colors.pinkAccent,
          fontFamily: GoogleFonts.lato().fontFamily,
        ),
        home: auth.isAuth
            ? ProductOverviewScreen()
            : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? SplashScreen()
                        : AuthScreen(),
              ),
        routes: {
          AuthScreen.routeName: (context) => AuthScreen(),
          SplashScreen.routeName: (context) => SplashScreen(),
          ProductOverviewScreen.routeName: (context) => ProductOverviewScreen(),
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CardScreen.routeName: (context) => CardScreen(),
          OrderScreen.routeName: (context) => OrderScreen(),
          UserProductScreen.routeName: (context) => UserProductScreen(),
          EditScreen.routeName: (context) => EditScreen(),
        },
      ),
    );
  }
}
