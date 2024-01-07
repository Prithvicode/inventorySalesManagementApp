import 'package:apitestapp/data/models/orderItem.dart';
import 'package:flutter/material.dart';

class OrderItemWidget extends StatefulWidget {
  OrderItem orderItem = OrderItem('', 0, 0.0);
  final int index;
  final List<String> products;
  final VoidCallback onRemove;

  OrderItemWidget(
      {required this.orderItem,
      required this.index,
      required this.products,
      required this.onRemove});

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  String selectedValue = '';
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    quantityController.text = widget.orderItem.quantity.toString();
    priceController.text = widget.orderItem.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // PRODUCT DROPDOWN
        DropdownButton<String>(
          value: selectedValue.isNotEmpty ? selectedValue : null,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
              widget.orderItem.selectedProduct = selectedValue;
            });
          },
          items: widget.products.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),

        // QUANTITY
        Expanded(
          child: TextFormField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantity',
            ),
            onChanged: (value) {
              setState(() {
                widget.orderItem.quantity = int.tryParse(value) ?? 0;
              });
            },
          ),
        ),

        // PRICE
        Expanded(
          child: TextFormField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Price',
            ),
            onChanged: (value) {
              setState(() {
                widget.orderItem.price = double.tryParse(value) ?? 0.0;
              });
            },
          ),
        ),

        // AMOUNT
        Text('\$${widget.orderItem.amount.toStringAsFixed(2)}'),

        // REMOVE ITEM BUTTON
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            setState(() {
              widget.onRemove();
            });
          },
        ),
      ],
    );
  }
}
