import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/pos_screen.dart';
import 'services/woocommerce_service.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(MyPOSApp());
}

class MyPOSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        Provider(create: (_) => WooCommerceService()),
      ],
      child: MaterialApp(
        title: 'POS WooCommerce',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: POSScreen(),
      ),
    );
  }
}
