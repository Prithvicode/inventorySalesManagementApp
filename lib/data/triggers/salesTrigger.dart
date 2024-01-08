import 'package:apitestapp/data/provider/inventory_api.dart';
import 'package:pocketbase/pocketbase.dart';

class SalesTrigger {
  final pb = PocketBase('https://draw-wire.pockethost.io');

  final InventoryApi _inventoryApi = InventoryApi();

  // helper function that get current stock.
  Future<void> reduceInventories(List orderItemsDetails) async {
    // for each product, need to update the availableStocks

    orderItemsDetails.forEach((element) async {
      int current_available_stocks =
          await _inventoryApi.getProductAvailableStock(element);
      print("Current availablePieces: $current_available_stocks");
    });
  }
}
