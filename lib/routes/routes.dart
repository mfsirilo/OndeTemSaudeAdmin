import 'package:flutter/cupertino.dart';
import 'package:onde_tem_saude_admin/ui/tabs/city_tab.dart';
import 'package:onde_tem_saude_admin/ui/tabs/contactus_tab.dart';
import 'package:onde_tem_saude_admin/ui/tabs/services_tab.dart';
import 'package:onde_tem_saude_admin/ui/tabs/specialties_tab.dart';
import 'package:onde_tem_saude_admin/ui/tabs/stores_tab.dart';
import 'package:onde_tem_saude_admin/ui/tabs/users_tab.dart';

class MenuPages {
  static Widget city = CityTab();
  static Widget store = StoresTab();
  static Widget specialties = SpecialtiesTab();
  static Widget services = ServicesTab();
  static Widget contact = ContactUsTab();
  static Widget user = UsersTab();
}
