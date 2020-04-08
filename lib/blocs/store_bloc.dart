import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class StoreBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  DocumentSnapshot store;

  Map<String, dynamic> unsavedData;

  StoreBloc({this.store}) {
    if (store != null) {
      unsavedData = Map.of(store.data);
      _createdController.add(true);
    } else {
      unsavedData = {
        "title": null,
        "description": null,
        "active": true,
        "latitude": 0,
        "longitude": 0,
        "address": null,
        "city": null,
        "district": null,
        "state": "GO",
        "country": "Brasil",
        "cep": null,
        "phone1": null,
        "phone2": null,
        "images": [],
      };
      _createdController.add(false);
    }

    _dataController.add(unsavedData);
  }

  void saveAddress(String address) {
    unsavedData["address"] = address;
  }

  void savePhone1(String phone1) {
    unsavedData["phone1"] = phone1;
  }

  void savePhone2(String phone2) {
    unsavedData["phone2"] = phone2;
  }

  void saveCep(String cep) {
    unsavedData["cep"] = cep;
  }

  void saveTitle(String title) {
    unsavedData["title"] = title;
  }

  void saveDescription(String description) {
    unsavedData["description"] = description;
  }

  void saveCity(var city) {
    unsavedData["city"] = city;
  }

  void saveDistrict(var district) {
    unsavedData["district"] = district;
  }

  void saveActive(bool active) {
    unsavedData["active"] = active;
  }

  void saveLatitude(double latitude) {
    unsavedData["latitude"] = latitude;
  }

  void saveLongitude(double longitude) {
    unsavedData["longitude"] = longitude;
  }

  void saveImages(List images) {
    unsavedData["images"] = images;
  }

  Future<bool> saveStore() async {
    _loadingController.add(true);

    try {
      if (store != null) {
        await _uploadImages(store.documentID);
        await store.reference.updateData(unsavedData);
      } else {
        DocumentReference dr = await Firestore.instance
            .collection("stores")
            .add(Map.from(unsavedData)..remove("images"));
        await _uploadImages(dr.documentID);
        await dr.updateData(unsavedData);
      }

      _createdController.add(true);
      _loadingController.add(false);
      return true;
    } catch (e) {
      _loadingController.add(false);
      return false;
    }
  }

  Future _uploadImages(String storeId) async {
    for (int i = 0; i < unsavedData["images"].length; i++) {
      if (unsavedData["images"][i] is String) continue;

      StorageUploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(storeId)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(unsavedData["images"][i]);

      StorageTaskSnapshot s = await uploadTask.onComplete;
      String downloadUrl = await s.ref.getDownloadURL();

      unsavedData["images"][i] = downloadUrl;
    }
  }

  void deleteStore() {
    store.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }
}
