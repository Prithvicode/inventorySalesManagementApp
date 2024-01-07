class OrderItem {
  String selectedProduct = '';
  int quantity = 0;
  double price = 0.0;

  OrderItem(this.selectedProduct, this.quantity, this.price);

  // setter
  // void setSelecteProduct(String selectedProductName) {
  //   this.selectedProduct = selectedProductName;
  // }

  //getter

  double get amount => quantity * price;
}
