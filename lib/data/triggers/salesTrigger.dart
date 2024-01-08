import 'package:apitestapp/data/provider/inventory_api.dart';
import 'package:pocketbase/pocketbase.dart';

class SalesTrigger {
  final pb = PocketBase('https://draw-wire.pockethost.io');

  final InventoryApi _inventoryApi = InventoryApi();

  // helper function that get current stock.
  Future<void> reduceInventories(var orderItemsDetails) async {
    // for each product, need to update the availableStocks

    orderItemsDetails.forEach((element) async {
      int current_available_stocks =
          await _inventoryApi.getProductAvailableStock(element[8]); // productId
      int updated_quantity = current_available_stocks - int.parse(element[5]);

      print("Current availablePieces: $current_available_stocks");
      print("updaed quantity${updated_quantity}");

      // Get product Name from Id

      final data = {
        // "productName": IdProductMatch[element[8]],
        "availablePieces": updated_quantity,
      };

      final record =
          await pb.collection('product').update(element[8], body: data);
    });
  }

  Future<void> udpateOrderStatus(String orderId) async {
    // update the order Status to completed.
    // Get product Name from Id
    final data = {"orderStatus": "Completed"};

    final record = await pb.collection('order').update(orderId, body: data);
  }
}
