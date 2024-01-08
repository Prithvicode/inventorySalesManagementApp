import 'package:apitestapp/data/provider/inventory_api.dart';
import 'package:pocketbase/pocketbase.dart';

InventoryApi _inventoryApi = InventoryApi();

class ProductionInventoryTrigger {
  final pb = PocketBase('https://draw-wire.pockethost.io');

  Future<void> addInventory(
      String productId, String productName, int quantity) async {
    int current_available_stocks =
        await _inventoryApi.getProductAvailableStock(productId);
    print("Current availablePieces: $current_available_stocks");
    int updated_quantity = current_available_stocks + quantity;
    print("updated quantity $updated_quantity");

    if (current_available_stocks > 0) {
      final data = {
        "productName": productName,
        "availablePieces": updated_quantity,
      };

      // update query
      final record =
          await pb.collection('product').update(productId, body: data);
    } else {
      print("current inventory is negative");
    }
  }

  Future<void> updateInventory(String productId, String productName,
      int quantity, int prev_quantity) async {
    int current_available_stocks =
        await _inventoryApi.getProductAvailableStock(productId);
    print("Current availablePieces: $current_available_stocks");

    int updated_quantity = current_available_stocks - prev_quantity + quantity;
    print("updated quantity $updated_quantity");

    if (current_available_stocks > 0) {
      final data = {
        "productName": productName,
        "availablePieces": updated_quantity,
      };

      // update query
      final record =
          await pb.collection('product').update(productId, body: data);
    } else {
      print("current inventory is negative");
    }
  }

  Future<void> reduceInventory(
    String productId,
    String productName,
    int quantity,
  ) async {
    int current_available_stocks =
        await _inventoryApi.getProductAvailableStock(productId);
    print("Current availablePieces: $current_available_stocks");

    int updated_quantity = current_available_stocks - quantity;
    print("updated quantity $updated_quantity");

    if (current_available_stocks > 0) {
      final data = {
        "productName": productName,
        "availablePieces": updated_quantity,
      };

      // update query
      final record =
          await pb.collection('product').update(productId, body: data);
    } else {
      print("current inventory is negative");
    }
  }
}
