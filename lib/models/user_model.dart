class UserModel {
  String name;
  String email;
  bool active;
  String address;
  String city;
  String district;
  String state;
  String country;
  String cep;
  String phone1;
  String phone2;
  String type;

  UserModel(
      {this.name,
      this.email,
      this.active,
      this.address,
      this.city,
      this.district,
      this.state,
      this.country,
      this.cep,
      this.phone1,
      this.phone2,
      this.type});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    active = json['active'];
    address = json['address'];
    city = json['city'];
    district = json['district'];
    state = json['state'];
    country = json['country'];
    cep = json['cep'];
    phone1 = json['phone1'];
    phone2 = json['phone2'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['active'] = this.active;
    data['address'] = this.address;
    data['city'] = this.city;
    data['district'] = this.district;
    data['state'] = this.state;
    data['country'] = this.country;
    data['cep'] = this.cep;
    data['phone1'] = this.phone1;
    data['phone2'] = this.phone2;
    data['type'] = this.type;
    return data;
  }

  static Map<String, dynamic> toDefaultJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = null;
    data['description'] = null;
    data['active'] = true;
    data['address'] = null;
    data['city'] = null;
    data['district'] = null;
    data['state'] = "GO";
    data['country'] = "Brasil";
    data['cep'] = null;
    data['phone1'] = null;
    data['phone2'] = null;
    data['type'] = "user";
    return data;
  }
}
