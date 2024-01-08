import 'dart:async';
// import 'package:apitestapp/components/pendingOrders/orderForm.dart';
import 'package:apitestapp/components/production/productionForm.dart';
import 'package:apitestapp/components/sales/showOrderDetails.dart';
import 'package:apitestapp/data/provider/order_api.dart';
import 'package:flutter/material.dart';

class PendingOrderPage extends StatefulWidget {
  const PendingOrderPage({Key? key}) : super(key: key);

  @override
  State<PendingOrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<PendingOrderPage> {
  List pendingOrders = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadPendingOrders();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadPendingOrders() async {
    try {
      final ordersApi = OrderApi();
      List pendingOrderList = (await ordersApi.getAllPendingOrder())!;
      setState(() {
        pendingOrders = pendingOrderList;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Orders for Sales'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Order Id')),
                    DataColumn(label: Text('Created Date')),
                    DataColumn(label: Text('Order Staff Id')), // name
                    DataColumn(label: Text('Customer Id')),
                    DataColumn(label: Text('Due Date')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: buildRows(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => OrderFormPage(),
          //   ),
          // );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<DataRow> buildRows() {
    List data = pendingOrders;

    return data.map((row) {
      return DataRow(
        cells: [
          DataCell(Text(row[0])), // orderID
          DataCell(Text(row[5])),
          DataCell(Text(row[6])),
          DataCell(Text(row[7])),
          DataCell(Text(row[8])),
          DataCell(Text(row[9])),
        ],
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetailsPage(
                      orderId: row[0],
                    )), // Send order ID
          );
        },
      );
    }).toList();
  }
}
