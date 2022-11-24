class Tutorial {
  String? header;
  List<String>? content;

  Tutorial({this.header, this.content});

  Tutorial.fromJson(Map<String, dynamic> json) {
    header = json['header'];
    content = json['content'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['header'] = this.header;
    data['content'] = this.content;
    return data;
  }
}