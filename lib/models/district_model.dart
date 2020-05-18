class DistrictModel {
  String name;
  bool active;

  DistrictModel({this.name, this.active});

  DistrictModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['active'] = this.active;
    return data;
  }

  static Map<String, dynamic> toDefaultJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = "";
    data['active'] = true;
    return data;
  }
}
