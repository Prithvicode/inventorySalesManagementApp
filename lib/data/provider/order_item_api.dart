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

  final productIdMatch = {
    "Chi Momo": "h3jn9e18t918jjw",
    "Veg Momo": "roivwboyvm2pfje",
    "Pork Momo": "zf8j99zl4ft79lf",
    "Buff Momo": "305fxlc0m9o76p1",
  };

  // POST METHOD
  Future<void> postOrderItems(String orderId, var orderItemsDetails) async {
    final body = <String, dynamic>{
      "orderId": orderId,
      "productId": productIdMatch[orderItemsDetails[0]],
      "quantity": orderItemsDetails[1],
      "price": orderItemsDetails[2],
      "amount": orderItemsDetails[3],
    };

    //test
    // print(orderId);
    // print(orderItemsDetails);

    final record = await pb.collection('orderItem').create(body: body);
  }

  Future<List<List<String>>> getOrderItemsFromOrderId(String orderId) async {
    List<List<String>> orderItems = [];
    try {
      final records =
          await pb.collection('orderItem').getFullList(sort: '-created');

      // get order Item from orderID,

      records.forEach((element) {
        if (element.getDataValue('orderId').toString() == orderId) {
          orderItems.add([
            element.id,
            element.created,
            element.collectionId,
            element.collectionName,
            element.updated,
            element.getDataValue('quantity').toString(), // 5
            element.getDataValue<String>('price').toString(),
            element.getDataValue<String>('amount').toString(), // 7
            element.getDataValue<String>('productId').toString(), // 8
          ]);
        }
      });
      // print("Order Items of id: ${orderId}");
      // print(orderItems);
    } catch (error) {
      print("Error: $error");
    }
    return orderItems;
  }
}
