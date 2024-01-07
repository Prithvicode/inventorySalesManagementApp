import 'package:apitestapp/data/provider/inventory_api.dart';
import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<InventoryPage> {
  List inventories = [];

  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadProductions();
  }

  Future<void> loadProductions() async {
    try {
      final inventoryApi = InventoryApi();
      inventories = (await inventoryApi.getAllInventory())!;
      // print(inventories); // [[id, created, udpated, fiest],[],[]]

      setState(() {
        isLoaded = true;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('Inventory Table'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Product ID')),
                DataColumn(label: Text('Product Name')),
                DataColumn(label: Text(' Available Pieces')),
              ],
              rows: buildRows(),
            ),
          )
        ]) // Pass your 2D list here
            ),
      ),
    ));
  }

  List<DataRow> buildRows() {
    // Replace this with your actual 2D list data
    List data = inventories;

    return data.map((row) {
      return DataRow(
        cells: [
          DataCell(Text(row[0])),
          DataCell(Text(row[5])),
          DataCell(Text(row[6])),
        ],
      );
    }).toList();
  }
}
