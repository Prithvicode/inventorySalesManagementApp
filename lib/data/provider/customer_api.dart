import 'package:pocketbase/pocketbase.dart';

class TaxableCustomerApi {
  final pb = PocketBase('https://draw-wire.pockethost.io');

  Future<List<String>> getAllTaxableCustomerNames() async {
    List<String> taxableCustomers = [];

    try {
      final records = await pb.collection('taxableCustomer').getFullList(
            sort: '-created',
          );
      records.forEach((element) {
        String customerName = element.getDataValue('customerName').toString();
        taxableCustomers.add(customerName);
      });
    } catch (error) {
      print("Error: $error");
    }
    return taxableCustomers;
  }

  Future<String> getCustomerIdFromName(String customerName) async {
    var customerIdPair = {};
    try {
      final records = await pb.collection('taxableCustomer').getFullList(
            sort: '-created',
          );
      records.forEach((element) {
        customerIdPair[element.getDataValue('customerName')] = element.id;
      });
      print("CUstomerID pait match Value: " +
          customerIdPair[customerName].toString());

      return customerIdPair[customerName].toString();
    } catch (error) {
      print(error);
      // Handle error if necessary
      throw 'Error occurred while getting customer ID'; // Change the message accordingly
    }
  }
}
