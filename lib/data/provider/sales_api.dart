import 'package:apitestapp/data/triggers/salesTrigger.dart';
import 'package:pocketbase/pocketbase.dart';

class SalesApi {
  final pb = PocketBase('https://draw-wire.pockethost.io');

  SalesTrigger _salesTrigger = SalesTrigger();

  Future<List?>? getAllSales() async {
    List sales = [];

    try {
      final records = await pb.collection('sales').getFullList(
            sort: '-created',
          );
      records.forEach((element) {
        sales.add([
          element.id,
          element.created,
          element.collectionId,
          element.collectionName,
          element.updated,
          element.getDataValue('paymentType').toString(), //5
          element.getDataValue('deliveryStaffId').toString(),
          element.getDataValue('totalAmount').toString(),
          element.getDataValue('discount').toString(),
          element.getDataValue('tax').toString(),
          element.getDataValue('payableAmount').toString(),
          element.getDataValue('cashRecieved').toString(),
          element.getDataValue('orderId').toString(), //12
        ]);
      });
    } catch (error) {
      print("Error: $error");
    }
    return sales;
  }

  // POST METHOD
  Future<void> postSales(paymentType, deliveryStaffID, totalAmount, discount,
      tax, payableAmount, cashReceived, orderId, orderItemsDetails) async {
    final body = <String, dynamic>{
      "paymentType": paymentType,
      "deliveryStaffId": deliveryStaffID,
      "totalAmount": totalAmount,
      "discount": discount,
      "tax": tax,
      "payableAmount": payableAmount,
      "cashRecieved": cashReceived,
      "orderId": orderId,
    };

    final record = await pb.collection('sales').create(body: body);

    // Trigger order update
    _salesTrigger.udpateOrderStatus(orderId);
    // Trigger inventory update
    _salesTrigger.reduceInventories(orderItemsDetails);
  }
}
