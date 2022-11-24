class CustomerDetails {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? address;

  CustomerDetails(
      {this.firstName, this.lastName, this.email, this.phone, this.address});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    return data;
  }
}