import 'package:pocketbase/pocketbase.dart';

class OrderApi {
  final pb = PocketBase('https://draw-wire.pockethost.io');

  Future<List?>? getAllOrder() async {
    List orders_history = [];

    try {
      final records =
          await pb.collection('order').getFullList(sort: '-created');
      records.forEach((element) {
        orders_history.add([
          element.id,
          element.created,
          element.collectionId,
          element.collectionName,
          element.updated,
          element.getDataValue('orderCreationDate').toString(), //5
          element.getDataValue<String>('orderStaffId').toString(),
          element.getDataValue<String>('customerId').toString(),
          element.getDataValue('orderDueDate').toString(),
          element.getDataValue<String>('orderStatus').toString(),
        ]);
      });
    } catch (error) {
      print("Error: $error");
    }
    return orders_history;
  }

  // POST METHOD
  Future<String> postOrder(orderCreationDate, orderStaffID, customerId,
      orderDueDate, orderStatus) async {
    final body = <String, dynamic>{
      "orderCreationDate": orderCreationDate,
      "orderStaffId": orderStaffID,
      "customerId": customerId,
      "orderDueDate": orderDueDate,
      "orderStatus": orderStatus
    };
    //test
    // print("Check for postOrder Values" +
    //     orderCreationDate +
    //     orderStaffID +
    //     customerId +
    //     orderDueDate +
    //     orderStatus);

    final record = await pb.collection('order').create(body: body);
    return record.id;
  }
}
