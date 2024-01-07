import 'package:apitestapp/pages/productionPage.dart';
import 'package:flutter/material.dart';

class ConfirmAlertBox {
  final String message;
  final VoidCallback? onConfirm;
  const ConfirmAlertBox({required this.message, required this.onConfirm});

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // User pressed Cancel
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // User pressed Confirm
                onConfirm;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProductionPage()));
                // Close the dialog
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
