import 'package:apitestapp/data/models/orderItem.dart';
import 'package:flutter/material.dart';

class OrderItemWidget extends StatefulWidget {
  OrderItem orderItem = OrderItem('', 0, 0.0);
  final int index;
  final List<String> products;
  final VoidCallback onRemove;
  final void Function(OrderItem, int) onSelectedValueChanged;

  OrderItemWidget(
      {required this.orderItem,
      required this.index,
      required this.products,
      required this.onRemove,
      required this.onSelectedValueChanged});

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  String selectedValue = '';
  TextEditingController selectedValueController = TextEditingController();

  // TextEditingController quantityController = TextEditingController();
  // TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedValueController.text = widget.orderItem.selectedProduct;
    //   quantityController.text = widget.orderItem.quantity.toString();
    //   priceController.text = widget.orderItem.price.toString();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // PRODUCT DROPDOWN
        DropdownButton<String>(
          value: widget.orderItem.selectedProduct.isNotEmpty
              ? widget.orderItem.selectedProduct
              : null,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
              widget.orderItem.selectedProduct = selectedValue;
              // Call the callback to update orderItemsDetails
              widget.onSelectedValueChanged(widget.orderItem, widget.index);
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
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantity',
            ),
            onChanged: (value) {
              setState(() {
                widget.orderItem.quantity = int.tryParse(value) ?? 0;
                widget.onSelectedValueChanged(widget.orderItem, widget.index);
              });
            },
          ),
        ),

        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Price',
            ),
            onChanged: (value) {
              setState(() {
                widget.orderItem.price = double.tryParse(value) ?? 0.0;
                widget.onSelectedValueChanged(widget.orderItem, widget.index);
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
