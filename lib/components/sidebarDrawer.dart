import 'package:apitestapp/pages/homePage.dart';
import 'package:apitestapp/pages/inventoryPage.dart';
import 'package:apitestapp/pages/orderPage.dart';
import 'package:apitestapp/pages/productionPage.dart';
import 'package:apitestapp/pages/salesPage.dart';
import 'package:flutter/material.dart';

class SidebarDrawer extends StatefulWidget {
  const SidebarDrawer({super.key});

  @override
  State<SidebarDrawer> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SidebarDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: const Color(Colors.black),
      child: Center(
        child: ListView(
          children: [
            ListTile(
              title: const Text("Home"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              },
            ),
            ListTile(
              title: const Text("Inventory"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InventoryPage(),
                    ));
              },
            ),
            ListTile(
              title: const Text("Production"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductionPage(),
                    ));
              },
            ),
            ListTile(
              title: const Text("Order"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPage(),
                    ));
              },
            ),
            ListTile(
              title: const Text("Sales"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalesPage(),
                    ));
              },
            )
          ],
        ),
      ),
    );
  }
}
