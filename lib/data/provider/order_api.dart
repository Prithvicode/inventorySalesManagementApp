import 'package:pocketbase/pocketbase.dart';

class OrderApi {
  final pb = PocketBase('https://draw-wire.pockethost.io');

  Future<List?>? getAllOrder() async {
    List pending_orders = [];

    try {
      final record = await pb.collection('order').getFullList(sort: '-created');
      record.forEach((record) {
        pending_orders.add([
          record.id,
          record.created,
          record.collectionId,
          record.collectionName,
          record.updated,
          record.getDataValue('orderCreationDate').toString(), //5
          record.getDataValue<String>('orderStaffId').toString(),
          record.getDataValue<String>('customerId').toString(),
          record.getDataValue('orderDueDate').toString(),
          record.getDataValue<String>('orderStatus').toString(),
        ]);
      });
    } catch (error) {
      print("Error: $error");
    }
    return pending_orders;
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

  Future<List?>? getAllPendingOrder() async {
    List pending_orders = [];

    try {
      final record = await pb.collection('order').getFullList(sort: '-created');

      record.forEach((record) {
        // pending filter
        if (record
                .getDataValue<String>('orderStatus')
                .toString()
                .toLowerCase() ==
            "pending") {
          // add those in return list
          pending_orders.add([
            record.id,
            record.created,
            record.collectionId,
            record.collectionName,
            record.updated,
            record.getDataValue('orderCreationDate').toString(), //5
            record.getDataValue<String>('orderStaffId').toString(),
            record.getDataValue<String>('customerId').toString(),
            record.getDataValue('orderDueDate').toString(),
            record.getDataValue<String>('orderStatus').toString()
          ]);
        }
      });
    } catch (error) {
      print("Error: $error");
    }
    return pending_orders;
  }

  Future<List<String>?> getOnePendingOrder(String orderId) async {
    try {
      final record = await pb.collection('order').getOne(orderId);

      // add those in return list
      List<String> order = [
        record.id.toString(),
        record.created.toString(),
        record.collectionId.toString(),
        record.collectionName.toString(),
        record.updated.toString(),
        record.getDataValue('orderCreationDate').toString(), //5
        record.getDataValue<String>('orderStaffId').toString(),
        record.getDataValue<String>('customerId').toString(),
        record.getDataValue('orderDueDate').toString(),
        record.getDataValue<String>('orderStatus').toString()
      ];
      print(order);
      return order;
    } catch (error) {
      print("Error: $error");
    }
  }
}
