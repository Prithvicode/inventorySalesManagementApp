import 'package:apitestapp/components/orders/orderItemWidget.dart';
import 'package:apitestapp/data/models/orderItem.dart';
import 'package:flutter/material.dart';

// Collection of Order items details.

class OrderItemFormWidget extends StatefulWidget {
  var orderItemsDetails; // collection of all the order items.

  OrderItemFormWidget({required this.orderItemsDetails});
  @override
  State<OrderItemFormWidget> createState() => _OrderFormPageState();
}

class _OrderFormPageState extends State<OrderItemFormWidget> {
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
                    },
                    onSelectedValueChanged: (orderItem, index) {
                      // Handle the selected value change here
                      setState(() {
                        widget.orderItemsDetails[index] = [
                          orderItem.selectedProduct,
                          orderItem.quantity,
                          orderItem.price,
                          orderItem.amount
                        ];
                      });
                    }))
                .toList(),
          ),
        ],
      ),
    );
  }
}
