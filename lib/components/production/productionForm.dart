import 'package:apitestapp/data/provider/production_api.dart';
import 'package:apitestapp/pages/productionPage.dart';
import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';

class ProductionFormPage extends StatefulWidget {
  ProductionFormPage({Key? key}) : super(key: key);

  @override
  State<ProductionFormPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProductionFormPage> {
  final _formKey = GlobalKey<FormState>();

  ProductionApi _productionApi = new ProductionApi();
  List<String> names = ['Chi Momo', 'Veg Momo', 'Pork Momo', 'Buff Momo'];
  List<String> size = ['Big', 'Small'];
  String selectedName = 'Chi Momo';
  String selectedsize = 'Big';
  DateTime? selectedDate;

  TextEditingController productNameController = TextEditingController();
  TextEditingController productSizeController = TextEditingController();

  TextEditingController productionStaffIdController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController productionDateController = TextEditingController();

  Future<void> _selectedDate(BuildContext context) async {
    final NepaliDateTime? picked = await picker.showMaterialDatePicker(
      context: context,
      initialDate: NepaliDateTime.now(),
      firstDate: NepaliDateTime(2000),
      lastDate: NepaliDateTime(2090),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        productionDateController.text =
            picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Set default values
    productNameController.text = selectedName;
    productSizeController.text = selectedsize;
  }

  @override
  void dispose() {
    productNameController.dispose();
    productionStaffIdController.dispose();
    quantityController.dispose();
    productionDateController.dispose();
    super.dispose();
  }

  void defaultSelected(String? newValue) {
    if (newValue != null) {
      selectedName = newValue;
    }
    productNameController.text = selectedName;
    productSizeController.text = selectedsize;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Production Page'),
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
                      productionStaffIdController.text = selectedsize;
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
                      _productionApi.postProduction(
                          productNameController.text,
                          quantityController.text,
                          "23", // productionStaffID,
                          productionDateController.text);

                      // Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProductionPage()),
                      );
                    }

                    // Trigger the callback to add the entry to the table on the home page

                    // Navigate back to the home page after submission
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
