import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class CityBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  DocumentSnapshot register;

  Map<String, dynamic> unsavedData;

  CityBloc({this.register}) {
    if (register != null) {
      unsavedData = Map.of(register.data);
      _createdController.add(true);
    } else {
      unsavedData = {
        "name": null,
        "active": true,
      };
      _createdController.add(false);
    }

    _dataController.add(unsavedData);
  }

  void saveName(String name) {
    unsavedData["name"] = name.toUpperCase();
  }

  void saveActive(bool value) {
    unsavedData["active"] = value;
  }

  Future<bool> save() async {
    _loadingController.add(true);

    try {
      if (register != null) {
        await register.reference.updateData(unsavedData);
      } else {
        DocumentReference dr = await Firestore.instance
            .collection("cities")
            .add(unsavedData);
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

  void delete() {
    register.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }
}
