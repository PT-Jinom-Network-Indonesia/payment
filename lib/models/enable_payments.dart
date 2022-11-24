import 'package:payment/models/tutorial.dart';
import 'package:payment/pages/home/home_model.dart';

class EnabledPayments {
  String? type;
  String? category;
  String? categoryDname;
  String? name;
  String? logoUrl;
  List<Tutorial>? tutorial;
  num? adminFee;

  EnabledPayments(
      {this.type,
      this.category,
      this.categoryDname,
      this.name,
      this.logoUrl,
      this.tutorial,
      this.adminFee = 0,
      });

  EnabledPayments.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    category = json['category'];
    categoryDname = json['category_dname'];
    name = json['name'];
    logoUrl = json['logo_url'];
    adminFee = json['admin_fee'];
    if (json['tutorial'] != null) {
      tutorial = <Tutorial>[];
      json['tutorial'].forEach((v) {
        tutorial!.add(new Tutorial.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['category'] = this.category;
    data['category_dname'] = this.categoryDname;
    data['name'] = this.name;
    data['logo_url'] = this.logoUrl;
    if (this.tutorial != null) {
      data['tutorial'] = this.tutorial!.map((v) => v.toJson()).toList();
    }
    data['admin_fee'] = this.adminFee;
    return data;
  }
}