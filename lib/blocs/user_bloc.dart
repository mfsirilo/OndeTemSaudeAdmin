import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _errorController = BehaviorSubject<String>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<String> get outError => _errorController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  DocumentSnapshot user;

  Map<String, dynamic> unsavedData;

  UserBloc({this.user}) {
    if (user != null) {
      unsavedData = Map.of(user.data);
      _createdController.add(true);
    } else {
      unsavedData = {
        "name": null,
        "email": null,
        "state": "GO",
        "country": "Brasil",
        "address": null,
        "city": null,
        "district": null,
        "cep": null,
        "phone1": null,
        "phone2": null,
        "active": true,
        "type": "user"
      };
      _createdController.add(false);
    }

    _dataController.add(unsavedData);
  }

  void saveName(String name) {
    unsavedData["name"] = name;
  }

  void saveEmail(String email) {
    unsavedData["email"] = email;
  }

  void saveAddress(String address) {
    unsavedData["address"] = address;
  }

  void savePhone1(String phone1) {
    unsavedData["phone1"] = phone1;
  }

  void savePhone2(String phone1) {
    unsavedData["phone2"] = phone1;
  }

  void saveCep(String cep) {
    unsavedData["cep"] = cep;
  }

  void saveCity(var city) {
    unsavedData["city"] = city;
  }

  void saveDistrict(var district) {
    unsavedData["district"] = district;
  }

  void saveType(var type) {
    unsavedData["type"] = type;
  }

  void saveActive(bool active) {
    unsavedData["active"] = active;
  }

  Future<bool> saveUser() async {
    _loadingController.add(true);
    bool result = false;
    try {
      if (user != null) {
        await user.reference.updateData(unsavedData);
        result = true;
      } else {
        String email = unsavedData["email"].trim();
        AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: "123456");
        if (_authResult.user != null) {
          unsavedData["uid"] = _authResult.user.uid;
          DocumentReference dr = Firestore.instance
              .collection("users")
              .document(_authResult.user.uid);
          await dr.setData(unsavedData);
          result = true;
        } else {
          result = false;
        }
      }

      _createdController.add(true);
      _loadingController.add(false);
      return result;
    } catch (e) {
      _errorController.sink.add(e.toString());
      _loadingController.add(false);
      return false;
    }
  }

  void deleteUser() {
    user.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
    _errorController.close();
  }
}
