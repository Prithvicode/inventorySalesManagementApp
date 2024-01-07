import 'package:apitestapp/components/sidebarDrawer.dart';
import 'package:apitestapp/pages/inventoryPage.dart';
import 'package:apitestapp/pages/orderPage.dart';
import 'package:apitestapp/pages/productionPage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentIndex = 0;

  final List<Widget> pages = [
    Container(
      child: Center(child: Text('Home Page')),
    ),
    InventoryPage(),
    ProductionPage(),
    OrderPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      drawer: SidebarDrawer(),
      body: _buildPage(_currentIndex),
      bottomNavigationBar: SizedBox(
        child: ColoredBox(
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: GNav(
              gap: 8,
              color: Colors.white,
              activeColor: Colors.white,
              backgroundColor: Colors.black,
              tabBackgroundColor: Color.fromARGB(255, 47, 46, 46),
              padding: EdgeInsets.all(16),
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                print(index);
                setState(() {
                  _currentIndex = index;
                });
              },
              tabs: [
                GButton(icon: Icons.home, text: "Home"),
                GButton(icon: Icons.inventory, text: "Stocks"),
                GButton(icon: Icons.factory, text: "Production"),
                GButton(icon: Icons.receipt_long_outlined, text: "Orders"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    return pages[index];
  }
}
