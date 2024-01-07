import 'dart:async';

import 'package:apitestapp/data/provider/sales_api.dart';
import 'package:flutter/material.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  List sales = [];

  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadProductions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadProductions() async {
    try {
      final salesApi = SalesApi();
      List salesHistory = (await salesApi.getAllSales())!;

      setState(() {
        isLoaded = true;
        sales = salesHistory;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales History'),
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
                    DataColumn(label: Text('Payable Amount')),
                    DataColumn(label: Text('Payment Type')),
                    DataColumn(label: Text('Cash Received')),
                    DataColumn(label: Text('Delivery Staff')),
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
          //     builder: (context) => ProductionFormPage(),
          //   ),
          // );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<DataRow> buildRows() {
    List data = sales;

    return data.map((row) {
      return DataRow(
        cells: [
          DataCell(Text(row[12])),
          DataCell(Text(row[10])),
          DataCell(Text(row[5])),
          DataCell(Text(row[11])),
          DataCell(Text(row[6])),
        ],
        onLongPress: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ProductionDetailPage(
          //       productName: row[9],
          //       productionId: row[0],
          //       productionDate: row[6],
          //       quantity: row[8],
          //       productionStaffId: row[7],
          //     ),
          //   ),
          // );
        },
      );
    }).toList();
  }
}
