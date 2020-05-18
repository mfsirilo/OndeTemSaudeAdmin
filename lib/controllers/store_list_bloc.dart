import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class StoreListBloc extends BlocBase {
  final _storesController = BehaviorSubject<List>();

  Stream<List> get outStores => _storesController.stream;

  List<DocumentSnapshot> _stores = [];

  Firestore _firestore = Firestore.instance;

  StoreListBloc() {
    _addStoreListener();
  }

  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _storesController.add(_stores.toList());
    } else {
      _storesController.add(_filter(search.trim()));
    }
  }

  void _addStoreListener() {
    _firestore
        .collection("stores")
        .orderBy('title')
        .snapshots()
        .listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _stores.add(change.document);
            break;
          case DocumentChangeType.modified:
            _stores.removeWhere((order) => order.documentID == uid);
            _stores.add(change.document);
            break;
          case DocumentChangeType.removed:
            _stores.removeWhere((order) => order.documentID == uid);
            break;
        }
      });
      _storesController.add(_stores);
    });
  }

  Future<List<DocumentSnapshot>> getStores() async {
    await Future.wait(_stores.map((value) async {
      var city = await Firestore.instance
          .collection("cities")
          .document(value.data["city"])
          .get();
      if (city.data != null) {
        value.data["cidade"] = city.data["name"];
        var district = await city.reference
            .collection("districts")
            .document(value.data["district"])
            .get();
        if (district.data != null) value.data["bairro"] = district.data["name"];
      }
    }));

    return _stores;
  }

  List<DocumentSnapshot> _filter(String search) {
    List<DocumentSnapshot> filteredStores = List.from(_stores.toList());

    filteredStores.retainWhere((store) {
      return store["title"].toUpperCase().contains(search.toUpperCase());
    });

    return filteredStores;
  }

  @override
  void dispose() {
    _storesController.close();
  }
}
