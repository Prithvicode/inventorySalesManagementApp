import 'package:pocketbase/pocketbase.dart';

class OrderItemApi {
  final pb = PocketBase('https://draw-wire.pockethost.io');

  Future<List?>? getAllOrderItem() async {
    List orderItems = [];

    try {
      final records =
          await pb.collection('orderItem').getFullList(sort: '-created');
      records.forEach((element) {
        orderItems.add([
          element.id,
          element.created,
          element.collectionId,
          element.collectionName,
          element.updated,
          element.getDataValue('quantity').toString(), //5
          element.getDataValue<String>('price').toString(),
          element.getDataValue<String>('amount').toString(),
          element.getDataValue('orderId').toString(),
          element.getDataValue<String>('productId').toString(),
        ]);
      });
    } catch (error) {
      print("Error: $error");
    }
    return orderItems;
  }
}
