import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:apitestapp/data/triggers/productionInventoryTrigger.dart';
import 'package:pocketbase/pocketbase.dart';

class ProductionApi {
  final pb = PocketBase('https://draw-wire.pockethost.io');
  // To get productId form productName
  final productIdMatch = {
    "Chi Momo": "h3jn9e18t918jjw",
    "Veg Momo": "roivwboyvm2pfje",
    "Pork Momo": "zf8j99zl4ft79lf",
    "Buff Momo": "305fxlc0m9o76p1",
  };
  final IdProductMatch = {
    "h3jn9e18t918jjw": "Chi Momo",
    "roivwboyvm2pfje": "Veg Momo",
    "zf8j99zl4ft79lf": "Pork Momo",
    "305fxlc0m9o76p1": "Buff Momo",
  };

  ProductionInventoryTrigger p_i_trigger = new ProductionInventoryTrigger();

  // GET METHOD
  Future<List?>? getAllProduction() async {
    List result = [];

// you can also fetch all records at once via getFullList

    try {
      final records =
          await pb.collection('production').getFullList(sort: '-created');
      records.forEach((element) {
        result.add([
          element.id,
          element.created,
          element.collectionId,
          element.collectionName,
          element.updated,
          element.getDataValue<String>('productId').toString(),
          element.getDataValue('productionDate').toString(),
          element.getDataValue<String>('productionStaffId').toString(),
          element.getDataValue<int>('quantity').toString(),
          IdProductMatch[element.getDataValue<String>('productId').toString()],
        ]);
      });
    } catch (error) {
      print("Error: $error");
    }
    return result;
  }

  // POST METHOD
  Future<void> postProduction(
      productName, quantity, productionStaffID, productionDate) async {
    final body = <String, dynamic>{
      "productId": productIdMatch[productName],
      "productionDate": productionDate,
      "productionStaffId": productionStaffID,
      "quantity": quantity,
    };
    //test
    print(productName + quantity + productionDate);

    final record = await pb.collection('production').create(body: body);

    // trigger to update the product available quantity.
    final add_trigger = await p_i_trigger.addInventory(
        productIdMatch[productName]!, productName, int.parse(quantity));
  }

  // PUT METHOD
  Future<void> updateProduction(productionId, productName, quantity,
      prev_quantity, productionStaffID, productionDate) async {
    final body = <String, dynamic>{
      "productId": productIdMatch[productName],
      "productionDate": productionDate,
      "productionStaffId": productionStaffID,
      "quantity": quantity,
    };
    //test
    print(productName + quantity + productionDate);

    final update_record =
        await pb.collection('production').update(productionId, body: body);

    final update_trigger = await p_i_trigger.updateInventory(
        productIdMatch[productName]!,
        productName,
        int.parse(quantity),
        int.parse(prev_quantity));
  }

  // DELETE METHOD
  Future<void> deleteProduction(productionId, productName, quantity,
      productionStaffID, productionDate) async {
    final body = <String, dynamic>{
      "productId": productIdMatch[productName],
      "productionDate": productionDate,
      "productionStaffId": productionStaffID,
      "quantity": quantity,
    };
    //test
    print(productName + quantity + productionDate);

    final delete_record =
        await pb.collection('production').delete(productionId);

    final delete_trigger = await p_i_trigger.reduceInventory(
      productIdMatch[productName]!,
      productName,
      int.parse(quantity),
    );
  }
}
