import 'package:apitestapp/components/orders/orderItemWidget.dart';
import 'package:apitestapp/data/models/orderItem.dart';
import 'package:flutter/material.dart';

// Collection of Order items details.

class OrderItemFormWidget extends StatefulWidget {
  @override
  State<OrderItemFormWidget> createState() => _OrderFormPageState();
}

void getEachOrderItemDetail(List itemDetails) {
  List itemDetailsCollection = [];
  itemDetailsCollection.add(itemDetails);
}

class _OrderFormPageState extends State<OrderItemFormWidget> {
  var orderItemsDetails = []; // collection of all the order items.
  List<OrderItem> orderItems = [];
  List<String> products = ['Pork Momo', 'Veg Momo', 'Buff Momo', 'Chi Momo'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                orderItems.add(OrderItem('', 0, 0.0));
              });
            },
            child: Text('Add Item'),
          ),
          SizedBox(height: 16),
          Column(
            children: orderItems
                .asMap()
                .entries
                .map((entry) => OrderItemWidget(
                    orderItem: entry.value,
                    index: entry.key,
                    products: products,
                    onRemove: () {
                      setState(() {
                        orderItems.removeAt(entry.key);
                      });
                    }))
                .toList(),
          ),
        ],
      ),
    );
  }
}
