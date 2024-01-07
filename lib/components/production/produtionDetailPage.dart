import 'package:apitestapp/components/production/confirmAlertBox.dart';
import 'package:apitestapp/components/production/productionUpdateForm.dart';
import 'package:apitestapp/data/provider/production_api.dart';
import 'package:apitestapp/pages/productionPage.dart';
import 'package:flutter/material.dart';

class ProductionDetailPage extends StatefulWidget {
  final String productionId;
  final String productName;
  final String productionDate;
  final String quantity;
  final String productionStaffId;

  ProductionDetailPage(
      {super.key,
      required this.productName,
      required this.productionId,
      required this.productionDate,
      required this.quantity,
      required this.productionStaffId});

  @override
  State<ProductionDetailPage> createState() => _ProductionDetailPageState();
}

void onConfirmDelete(
    productionId, productName, quantity, productionStaffID, productionDate) {
  ProductionApi _productionApi = ProductionApi();
  _productionApi.deleteProduction(
      productionId, productName, quantity, productionStaffID, productionDate);
}

class _ProductionDetailPageState extends State<ProductionDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Date:${widget.productionDate}"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ProductionPage()));
          }
          // Navigator.pushNamed(context, '/prouduction');
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => ProductionPage()));
          ,
        ),
      ),
      body: Center(
        child: Column(children: [
          Text("Product Name: ${widget.productName}"),
          Text("Quantity: ${widget.quantity}"),
          Text("Date: ${widget.productionDate}"),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductionUpdateForm(
                          productName: widget.productName,
                          productionDate: widget.productionDate,
                          productionId: widget.productionId,
                          productionStaffId: widget.productionStaffId,
                          quantity: widget.quantity,
                        ),
                      ),
                    );
                  },
                  child: Icon(Icons.edit)),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          child: AlertDialog(
                            title: Text("Confirmation"),
                            content:
                                Text("Are you sure you want to delete this?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  onConfirmDelete(
                                      widget.productionId,
                                      widget.productName,
                                      widget.quantity,
                                      widget.productionStaffId,
                                      widget.productionDate);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductionPage()));
                                },
                                child: Text("Delete"),
                              ),
                              TextButton(
                                onPressed: () {
                                  // User pressed Cancel
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                        // ConfirmAlertBox(
                        //   message: "Do you really want to delete this?",
                        //   onConfirm: () {
                        //     onConfirmDelete(
                        //       widget.productionId,
                        //       widget.productName,
                        //       widget.quantity,
                        //       widget
                        //           .quantity, // Assuming prev_quantity is the same as quantity
                        //       widget.productionStaffId,
                        //       widget.productionDate,
                        //     );
                        //   },
                        // );
                      },
                    );
                  },
                  child: Icon(Icons.delete))
            ],
          )
        ]),
      ),
    );
  }
}
