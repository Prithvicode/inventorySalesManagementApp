import 'dart:async';
import 'package:apitestapp/components/orders/orderForm.dart';
import 'package:apitestapp/components/production/productionForm.dart';
import 'package:apitestapp/data/provider/order_api.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List orders = [];
  bool isLoaded = false;
  bool _mounted = false;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadOrders() async {
    try {
      final ordersApi = OrderApi();
      List ordersList = (await ordersApi.getAllOrder())!;
      setState(() {
        orders = ordersList;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Table'),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderFormPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<DataRow> buildRows() {
    List data = orders;

    return data.map((row) {
      return DataRow(
        cells: [
          DataCell(Text(row[5])),
          DataCell(Text(row[6])),
          DataCell(Text(row[7])),
          DataCell(Text(row[8])),
          DataCell(Text(row[9])),
        ],
        onLongPress: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ProductionDetailPage(
          //       productName: row[9],
          //       OrderId: row[0],
          //       OrderDate: row[6],
          //       quantity: row[8],
          //       orderstaffId: row[7],
          //     ),
          //   ),
          // );
        },
      );
    }).toList();
  }
}
