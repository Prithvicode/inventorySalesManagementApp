import 'dart:convert';
import 'package:pocketbase/pocketbase.dart';

class InventoryApi {
  final pb = PocketBase('https://draw-wire.pockethost.io');

  Future<List?>? getAllInventory() async {
    List inventory_list = [];

// you can also fetch all records at once via getFullList

    try {
      final records =
          await pb.collection('product').getFullList(sort: '-created');
      records.forEach((element) {
        inventory_list.add([
          element.id, // product ID
          element.created,
          element.collectionId,
          element.collectionName,
          element.updated,
          // element.getDataValue<String>('productId').toString(),
          element.getDataValue<String>('productName').toString(),
          element.getDataValue<int>('availablePieces').toString(),
        ]);
      });
    } catch (error) {
      print("Error: $error");
    }
    return inventory_list;
  }

// To get productId form productName
//   final productIdMatch = {
//     "Chi Momo": "h3jn9e18t918jjw",
//     "Veg Momo": "roivwboyvm2pfje",
//     "Pork Momo": "zf8j99zl4ft79lf",
//     "Buff Momo": "305fxlc0m9o76p1",
//   };
}
