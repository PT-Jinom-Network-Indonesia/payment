class ItemDetails {
  int? id;
  int? transactionId;
  String? name;
  String? customId;
  int? quantity;
  double? price;

  ItemDetails(
      {this.id,
      this.transactionId,
      this.name,
      this.customId,
      this.quantity,
      this.price});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    name = json['name'];
    customId = json['custom_id'];
    quantity = json['quantity'];
    price = json['price'] != null ? double.parse("${json['price']}") : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transaction_id'] = this.transactionId;
    data['name'] = this.name;
    data['custom_id'] = this.customId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    return data;
  }
}