class VirtualAccount {
  String? bank;
  String? vaNumber;
  static String bri = "bri";
  static String bca = "bca";
  static String bni = "bni";

  VirtualAccount({this.bank, this.vaNumber});

  VirtualAccount.fromJson(Map<String, dynamic> json) {
    bank = json['bank'];
    vaNumber = json['va_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bank'] = this.bank;
    data['va_number'] = this.vaNumber;
    return data;
  }
}