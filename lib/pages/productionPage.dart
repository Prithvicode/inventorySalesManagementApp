import 'dart:async';
import 'package:apitestapp/components/productionForm.dart';
import 'package:apitestapp/components/produtionDetailPage.dart';
import 'package:apitestapp/data/provider/production_api.dart';
import 'package:flutter/material.dart';

class ProductionPage extends StatefulWidget {
  const ProductionPage({Key? key}) : super(key: key);

  @override
  State<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  List productions = [];
  Timer? _timer;
  bool isLoaded = false;
  bool _mounted = false;

  @override
  void initState() {
    super.initState();
    _mounted = true;
    _startTimer();
    loadProductions();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      if (_mounted) {
        loadProductions();
      }
    });
  }

  @override
  void dispose() {
    _mounted = false;
    _timer?.cancel();
    super.dispose();
  }

  Future<void> loadProductions() async {
    try {
      final productionsApi = ProductionApi();
      List productionsList = (await productionsApi.getAllProduction())!;
      if (_mounted) {
        setState(() {
          isLoaded = true;
          productions = productionsList;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Production Table'),
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
                    DataColumn(label: Text('Product Name')),
                    DataColumn(label: Text('Production Date')),
                    DataColumn(label: Text('Production Staff ID')),
                    DataColumn(label: Text('Quantity')),
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
              builder: (context) => ProductionFormPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<DataRow> buildRows() {
    List data = productions;

    return data.map((row) {
      return DataRow(
        cells: [
          DataCell(Text(row[9])), // product Name
          DataCell(Text(row[6])), // prdtn Date
          DataCell(Text(row[7])), // prdtn_Stfid
          DataCell(Text(row[8])), // quantity
        ],
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductionDetailPage(
                productName: row[9],
                productionId: row[0],
                productionDate: row[6],
                quantity: row[8],
                productionStaffId: row[7],
              ),
            ),
          );
        },
      );
    }).toList();
  }
}
