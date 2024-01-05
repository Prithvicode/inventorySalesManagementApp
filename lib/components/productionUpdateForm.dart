import 'package:apitestapp/components/produtionDetailPage.dart';
import 'package:apitestapp/data/provider/production_api.dart';
import 'package:apitestapp/pages/productionPage.dart';
import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';

class ProductionUpdateForm extends StatefulWidget {
  final String productionId;
  final String productName;
  final String productionDate;
  final String quantity;
  final String productionStaffId;

  ProductionUpdateForm(
      {Key? key,
      required this.productName,
      required this.productionId,
      required this.productionDate,
      required this.quantity,
      required this.productionStaffId});

  @override
  State<ProductionUpdateForm> createState() => _ProductionUpdateState();
}

class _ProductionUpdateState extends State<ProductionUpdateForm> {
  final _formKey = GlobalKey<FormState>();

  ProductionApi _productionApi = new ProductionApi(); // update api

  List<String> names = ['Chi Momo', 'Veg Momo', 'Pork Momo', 'Buff Momo'];
  List<String> size = ['Big', 'Small'];
  late String selectedName;
  String selectedsize = 'Big';
  DateTime? selectedDate;

  late String
      prev_quantity; // to know the prev quantity to send it to update api

//  controllers defined, and will be initialized late.
  // late TextEditingController productSizeController;
  late TextEditingController productNameController;
  // late TextEditingController productionStaffIdController;
  late TextEditingController quantityController;
  late TextEditingController productionDateController;

  Future<void> _selectedDate(BuildContext context) async {
    final NepaliDateTime? picked = await picker.showMaterialDatePicker(
      context: context,
      initialDate: NepaliDateTime.now(),
      firstDate: NepaliDateTime(2000),
      lastDate: NepaliDateTime(2090),
    );

    if (picked != null && picked != widget.productionDate) {
      setState(() {
        selectedDate = picked;
        productionDateController.text =
            picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  void initState() {
    // previous quantity of product;
    prev_quantity = widget.quantity;

    // Set default values
    selectedName = widget.productName;
    productNameController = TextEditingController(text: widget.productName);
    productionDateController =
        TextEditingController(text: widget.productionDate);
    quantityController = TextEditingController(text: widget.quantity);
    // productionStaffIdController =
    //     TextEditingController(text: widget.productionStaffId);
    // productNameController = TextEditingController(text: widget.productName);
    // productNameController.text = productName;
    // productSizeController.text = selectedsize;
    super.initState();
  }

  @override
  void dispose() {
    productNameController.dispose();
    // productionStaffIdController.dispose();
    quantityController.dispose();
    productionDateController.dispose();
    super.dispose();
  }

  void defaultSelected(String? newValue) {
    if (newValue != null) {
      selectedName = newValue;
    }
    productNameController.text = selectedName;
    // productSizeController.text = selectedsize;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Production Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Details:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                //
                // Options for Product Name,
                DropdownButton<String>(
                  value: selectedName,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedName = newValue!;
                      productNameController.text = selectedName;
                    });
                  },
                  items: names.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                // Options for Product size,
                DropdownButton<String>(
                  value: selectedsize,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedsize = newValue!;
                      // productionStaffIdController.text = selectedsize;
                    });
                  },
                  items: size.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                // TextFormField(
                //   controller: priceController,
                //   decoration: InputDecoration(labelText: 'Price'),
                //   keyboardType: TextInputType.number,
                // ),

                TextFormField(
                    controller: quantityController,
                    decoration: InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter quantity';
                      }
                      return null;
                    }),

                // Date picker
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: productionDateController,
                        decoration: InputDecoration(
                          labelText: 'Date',
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Date';
                          }
                          return null;
                        },
                        readOnly: true,
                        onTap: () => _selectedDate(context),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectedDate(context),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  // Add form submission logic here
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Send to productionapi.postProduction details.
                      _productionApi.updateProduction(
                          widget.productionId,
                          productNameController.text,
                          quantityController.text,
                          prev_quantity,
                          widget.productionStaffId, // productionStaffID,
                          productionDateController.text);

                      // Navigator.of(context).pop();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductionDetailPage(
                                  productName: productNameController.text,
                                  productionDate: productionDateController.text,
                                  productionId: widget.productionId,
                                  productionStaffId: widget.productionStaffId,
                                  quantity: quantityController.text,
                                )),
                      );
                    }

                    // Trigger the callback to add the entry to the table on the home page

                    // Navigate back to the home page after submission
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
