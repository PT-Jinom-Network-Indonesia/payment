class Merchant {
  String? merchantName;
  String? merchantLogoUrl;
  String? storeColor;

  Merchant({this.merchantName, this.merchantLogoUrl, this.storeColor});

  Merchant.fromJson(Map<String, dynamic> json) {
    merchantName = json['merchant_name'] == null ? "Merchant" : json['merchant_name'];
    merchantLogoUrl = json['merchant_logo_url'];
    storeColor = json['store_color'] == null ? "000000" : json['store_color']; 
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchant_name'] = this.merchantName;
    data['merchant_logo_url'] = this.merchantLogoUrl;
    data['store_color'] = this.storeColor;
    return data;
  }
}