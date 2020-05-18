class CityModel {
  String name;
  bool active;

  CityModel({this.name, this.active});

  CityModel.fromJson(Map<String, dynamic> json) {
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
