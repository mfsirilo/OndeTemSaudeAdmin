import 'dart:ffi';

class StoreModel {
  String title;
  String description;
  bool active;
  Double latitude;
  Double longitude;
  String address;
  String city;
  String district;
  String state;
  String country;
  String cep;
  String phone1;
  String phone2;
  Object images;

  StoreModel(
      {this.title,
      this.description,
      this.active,
      this.latitude,
      this.longitude,
      this.address,
      this.city,
      this.district,
      this.state,
      this.country,
      this.cep,
      this.phone1,
      this.phone2,
      this.images});

  StoreModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    active = json['active'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    city = json['city'];
    district = json['district'];
    state = json['state'];
    country = json['country'];
    cep = json['cep'];
    phone1 = json['phone1'];
    phone2 = json['phone2'];
    images = json['images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['active'] = this.active;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['city'] = this.city;
    data['district'] = this.district;
    data['state'] = this.state;
    data['country'] = this.country;
    data['cep'] = this.cep;
    data['phone1'] = this.phone1;
    data['phone2'] = this.phone2;
    data['images'] = this.images;
    return data;
  }

  static Map<String, dynamic> toDefaultJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = null;
    data['description'] = null;
    data['active'] = true;
    data['latitude'] = 0;
    data['longitude'] = 0;
    data['address'] = null;
    data['city'] = null;
    data['district'] = null;
    data['state'] = "GO";
    data['country'] = "Brasil";
    data['cep'] = null;
    data['phone1'] = null;
    data['phone2'] = null;
    data['images'] = [];
    return data;
  }
}
