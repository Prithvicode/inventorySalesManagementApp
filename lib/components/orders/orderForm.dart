import 'package:apitestapp/components/orders/orderItemsFormWidget.dart';
import 'package:apitestapp/data/provider/customer_api.dart';
import 'package:apitestapp/data/provider/order_api.dart';
import 'package:apitestapp/data/provider/order_item_api.dart';
import 'package:apitestapp/pages/orderPage.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;

class OrderFormPage extends StatefulWidget {
  const OrderFormPage({Key? key}) : super(key: key);

  @override
  State<OrderFormPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<OrderFormPage> {
  final _formKey = GlobalKey<FormState>();

  List<String> orderStatusType = ['Pending', 'Completed', 'Cancelled'];
  String selectedOrderStatus = 'Pending';

// Api instances
  OrderApi _orderApi = OrderApi();
  OrderItemApi _orderItemApi = OrderItemApi();

  TaxableCustomerApi _customerApi =
      TaxableCustomerApi(); // Corrected instance creation

  DateTime selectedDate = NepaliDateTime.now();

  DateTime selectedDueDate = NepaliDateTime.now();

  bool isDueDateSelected = false;
  bool isCustomerNamesLoaded = false;
  String selectedCustomer = '';
  String selectedCustomerId = '';

  List<String> customersNames = []; // Corrected list type

  var orderItemDetails = {};

  TextEditingController orderCreationDateController = TextEditingController();
  TextEditingController orderStaffIdController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController orderDueDateController = TextEditingController();
  TextEditingController orderStatusController = TextEditingController();

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
        if (isDueDateSelected == false) {
          orderCreationDateController.text =
              picked.toLocal().toString().split(' ')[0];
        } else {
          orderDueDateController.text =
              picked.toLocal().toString().split(' ')[0];
        }
      });
    }
  }

  Future<void> _selectedDueDate(BuildContext context) async {
    final NepaliDateTime? picked = await picker.showMaterialDatePicker(
      context: context,
      initialDate: NepaliDateTime.now(),
      firstDate: NepaliDateTime(2000),
      lastDate: NepaliDateTime(2090),
    );

    if (picked != null && picked != selectedDueDate) {
      setState(() {
        selectedDueDate = picked;
        orderDueDateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Set default values
    orderCreationDateController.text =
        DateFormat('yyyy-MM-dd').format(selectedDate);
    orderDueDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);

    // Load customer names and set initial selected customer
    loadCustomerNames().then((customerNames) {
      if (customerNames.isNotEmpty) {
        setState(() {
          selectedCustomer = customerNames[0];
          customerNameController.text = selectedCustomer;
          loadCustomerIdFromName(selectedCustomer);
        });
      }
    });

    // Set default order status
    selectedOrderStatus = orderStatusType[0];
    orderStatusController.text = selectedOrderStatus;
  }

  // GET CUSTOMERS FOR SELECT OPTIONS
  Future<List<String>> loadCustomerNames() async {
    try {
      final customerApi = TaxableCustomerApi();
      List<String> customersList =
          await customerApi.getAllTaxableCustomerNames();

      if (isCustomerNamesLoaded == false) {
        selectedCustomer = customersList.isNotEmpty
            ? customersList[0]
            : ''; // initally when loaded, the firt item.
        setState(() {
          isCustomerNamesLoaded = true;
        });
      }

      return customersList;
    } catch (error) {
      print(error);
      return []; // Return an empty list or another default value
    }
  }

// GET PRODUCT ID FROM ITS NAME

  void loadCustomerIdFromName(String customerName) async {
    selectedCustomerId = await _customerApi.getCustomerIdFromName(customerName);
  }

  @override
  void dispose() {
    orderCreationDateController.dispose();
    orderDueDateController.dispose();
    customerNameController.dispose();
    orderStaffIdController.dispose();
    orderStatusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Order Page'),
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

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: orderCreationDateController,
                        decoration: InputDecoration(
                          labelText: "Order Creation Date",
                          hintText:
                              DateFormat('yyyy-MM-dd').format(selectedDate),
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Date';
                          }
                          return null;
                        },
                        readOnly: true,
                        onTap: () => {_selectedDate(context)},
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectedDate(context),
                    ),
                  ],
                ),

                // Dynamic Customer Dropdown menu:
                Text(
                  'Customer Name:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                FutureBuilder<List<String>>(
                  future: loadCustomerNames(),
                  builder: (context, snapshot) {
                    List<String> customerNames = snapshot.data ?? [];

                    return DropdownButton(
                      value: selectedCustomer,
                      items:
                          customerNames.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedCustomer = newVal!;
                          customerNameController.text = selectedCustomer;
                          if (selectedCustomer == '') {
                            customerNameController.text = customerNames[0];
                          }
                          // get id from name
                          loadCustomerIdFromName(customerNameController.text);
                        });
                      },
                    );
                  },
                ),

                // ORDER DUE DATE
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: orderDueDateController,
                        decoration: InputDecoration(
                          labelText: "Order Due Date",
                          hintText:
                              DateFormat('yyyy-MM-dd').format(selectedDueDate),
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Date';
                          }
                          return null;
                        },
                        readOnly: true,
                        onTap: () => _selectedDueDate(context),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectedDueDate(context),
                    ),
                  ],
                ),
                // ORDER STATUS DROPDOWN
                Text(
                  'Order Status:',
                  style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedOrderStatus,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOrderStatus = newValue!;
                      orderStatusController.text = selectedOrderStatus;
                    });
                  },
                  items: orderStatusType
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                // FORM
                OrderItemFormWidget(
                  orderItemsDetails: orderItemDetails,
                ),

                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      //  Post order To Order Table
                      String orderId = '';
                      Future<void> setOrderIdApiAfterOrderPost() async {
                        final orderIdResponse = await _orderApi.postOrder(
                          orderCreationDateController.text,
                          "23",
                          selectedCustomerId,
                          orderDueDateController.text,
                          orderStatusController.text,
                        );
                        setState(() {
                          orderId = orderIdResponse;
                        });
                      }

                      Future<void> processOrderItems() async {
                        await setOrderIdApiAfterOrderPost();

                        // POST ORDER TO ORDER ITEM TABLE if it's not empty
                        if (orderItemDetails.isNotEmpty && orderId != '') {
                          // Loop through order items in the orderItemDetails map.
                          for (var key in orderItemDetails.keys) {
                            await _orderItemApi.postOrderItems(
                                orderId, orderItemDetails[key]);
                          }

                          print(orderItemDetails);
                        }
                      }

                      // Calling function
                      processOrderItems();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderPage(),
                        ),
                      );
                    }
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
