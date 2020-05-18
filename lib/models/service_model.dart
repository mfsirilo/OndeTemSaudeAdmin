class ServiceModel {
  String name;

  ServiceModel({this.name});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }

  static Map<String, dynamic> toDefaultJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = "";
    return data;
  }
}
