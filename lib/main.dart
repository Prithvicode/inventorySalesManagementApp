import 'package:apitestapp/pages/homePage.dart';
import 'package:apitestapp/pages/inventoryPage.dart';
import 'package:apitestapp/pages/orderPage.dart';
import 'package:apitestapp/pages/productionPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const HomePage(),
        '/inventory': (BuildContext context) => const InventoryPage(),
        '/production': (BuildContext context) => const ProductionPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: OrderPage(),
    );
  }
}
