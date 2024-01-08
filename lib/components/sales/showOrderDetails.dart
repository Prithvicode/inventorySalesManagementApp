import 'package:apitestapp/components/sales/pendingOrderPage.dart';
import 'package:apitestapp/data/models/orderItem.dart';
import 'package:apitestapp/data/models/sales.dart';
import 'package:apitestapp/data/provider/order_api.dart';
import 'package:apitestapp/data/provider/order_item_api.dart';
import 'package:apitestapp/data/provider/sales_api.dart';
import 'package:apitestapp/pages/salesPage.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId; // get order Id
  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _MyWidgetState();
}

// Get Order detail
// Get the respective order details
// Send to add sales section
// select payment Type and CashReceived section
// Add the sales details to the Sales Tables
// Take order items, for each order item select the their current previous quantity
// create updated_quantity by adding the current quantity and quantity from order item.
// update the inventory level of respective products.
class _MyWidgetState extends State<OrderDetailsPage> {
  List selectedOrder = [];
  String selectedPaymentType = 'Cash';
  String selectedCashReceived = "Yes";
  int discount = 10;
  int tax = 13;
  String deliveryStaffId = "23";
  // Default value for the dropdown
  double totalAmount = 0.0;
  double payableAmount = 0.0;

  SalesApi _salesApi = SalesApi();
  var orderItemsDetails;

  @override
  void initState() {
    super.initState();
    getOrderDetails();
    getTotalAmountFromOrderItems();
  }

  Future<List<String>> getOrderDetails() async {
    try {
      final ordersApi = OrderApi();
      List<String> selectedOrder =
          (await ordersApi.getOnePendingOrder(widget.orderId))!;

      // Process the order details here instead of a separate method.
      List<String> orderDetails = [
        "Order Creation Date: ${selectedOrder[5]}",
        "Order Staff: ${selectedOrder[6]}",
        "Customer Name: ${selectedOrder[7]}",
        "Order Due Date: ${selectedOrder[8]}",
      ];
      print(orderDetails);
      return orderDetails;
    } catch (error) {
      print(error);
      throw error; // Propagate the error to FutureBuilder
    }
  }

  Future<List<List<String>>?> getOrderItemsDetails() async {
    OrderItemApi _orderItemApi = OrderItemApi();
    try {
      List<List<String>> itemsList =
          await _orderItemApi.getOrderItemsFromOrderId(widget.orderId);
      return itemsList;
    } catch (error) {
      print("Error: $error");
      // Handle the error, show an error message, or navigate to an error screen.
    }
  }

  Future<void> getTotalAmountFromOrderItems() async {
    double sum = 0.0;
    List<List<String>>? orderItems = await getOrderItemsDetails();
    if (orderItems != null && orderItems.isNotEmpty) {
      orderItems.forEach((element) {
        sum += double.parse(element[7]);
      });
      setState(() {
        totalAmount = sum;
        payableAmount = (totalAmount * 0.9) * (1.13);
        orderItemsDetails = orderItems;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Order Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text("Order Id: ${widget.orderId}"),
              FutureBuilder<List<String>>(
                future: getOrderDetails(),
                builder: (context, snapshot) {
                  List<String> orderDetails = snapshot.data ?? [];

                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: orderDetails.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index]),
                        );
                      });
                },
              ),
              Text("Order Items: "),
              FutureBuilder<List<List<String>>?>(
                future: getOrderItemsDetails(),
                builder: (context, snapshot) {
                  List<List<String>> itemsList = snapshot.data ?? [];

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < itemsList.length; i++)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Product: ${itemsList[i][8]}"),
                              SizedBox(width: 10),
                              Text("Quantity: ${itemsList[i][5]}"),
                              SizedBox(width: 10),
                              Text("Price: ${itemsList[i][6]}"),
                              SizedBox(width: 10),
                              Text("Amount: ${itemsList[i][7]}"),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: 10),

              // Sales Details:

              Column(
                children: [
                  Text("Total Amount: ${totalAmount}"),
                  Text("Payable Amount: ${payableAmount.toStringAsFixed(2)} "),
                ],
              ),
              SizedBox(height: 10),
              // PAYMENT TYPE
              DropdownButton<String>(
                // alignment: ,
                value: selectedPaymentType,
                onChanged: (newValue) {
                  setState(() {
                    selectedPaymentType = newValue!;
                  });
                },
                items: ['Cash', 'Online', 'Giveaway']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text('Select Payment Type'),
              ),
              SizedBox(height: 10),

              DropdownButton<String>(
                value: selectedCashReceived,
                onChanged: (newValue) {
                  setState(() {
                    selectedCashReceived = newValue!;
                  });
                },
                items:
                    ['Yes', 'No'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text('Cash Received:'),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // call post sales APi
                  _salesApi.postSales(
                      selectedPaymentType,
                      deliveryStaffId,
                      totalAmount,
                      discount,
                      tax,
                      payableAmount.toStringAsFixed(2),
                      selectedCashReceived,
                      widget.orderId,
                      orderItemsDetails);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PendingOrderPage()));

                  // print(widget.orderId);
                  // print(tax);
                  // print(discount);
                  // print(totalAmount);
                  // print(payableAmount);
                  print("Order Details: ");
                  print(orderItemsDetails);
                  // print(deliveryStaffId);
                  // print(selectedPaymentType);
                  // print(selectedCashReceived);
                },
                child: Text("Add Sales"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
