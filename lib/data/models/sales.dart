class Sales {
  final Future<String> paymentType;
  final String deliveryStaffId = "23";
  final double discount = 10;
  final Future<double> totalAmount;
  final Future<double> cashReceived;
  final Future<String> orderId;

  final double tax = 13;

  Sales(this.paymentType, this.totalAmount, this.cashReceived, this.orderId);

// getter
  Future<double> get payableAmount async => await _calculatePayableAmount();

  Future<double> _calculatePayableAmount() async {
    double totalAmountValue = await totalAmount;
    double payAmount = (totalAmountValue * 0.9) * (1.13);
    return payAmount;
  }
}



// class Sales {
//   String _paymentType;
//   String _deliveryStaffId;
//   double _totalAmount;
//   int _discount = 10;
//   int _tax = 13;
//   int _payableAmount;
//   // String _cashReceived;
//   // String _orderId;

//   Sales(
//       this._paymentType,
//       this._deliveryStaffId,
//       this._discount,
//       this._totalAmount,
//       // this._cashReceived,
//       // this._orderId,
//       this._payableAmount,
//       this._tax);

//   // getter
//   String get paymentType => this.paymentType;
//   String get deliveryStaffId => this.deliveryStaffId;
//   double get totalAmount => this._totalAmount;
//   int get discount => this.discount;
//   int get tax => this._tax;
//   int get payableAmount => this._payableAmount;
//   String get cashReceived => this._cashReceived;
//   String get orderId => this._orderId;

//   // double get payableAmount =>
// }
