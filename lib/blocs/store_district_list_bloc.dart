import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class StoreDistrictListBloc extends BlocBase {
  final _storesDistrictController = BehaviorSubject<List>();

  Stream<List> get outStoreDistrict => _storesDistrictController.stream;

  List<DocumentSnapshot> _storesDistrict = [];
  final DocumentSnapshot store;

  StoreDistrictListBloc({this.store}) {
    _addStoreListener();
  }

  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _storesDistrictController.add(_storesDistrict.toList());
    } else {
      _storesDistrictController.add(_filter(search.trim()));
    }
  }

  void _addStoreListener() {
    store.reference.collection("districts").snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _storesDistrict.add(change.document);
            break;
          case DocumentChangeType.modified:
            _storesDistrict.removeWhere((order) => order.documentID == uid);
            _storesDistrict.add(change.document);
            break;
          case DocumentChangeType.removed:
            _storesDistrict.removeWhere((order) => order.documentID == uid);
            break;
        }
      });
      _storesDistrictController.add(_storesDistrict);
    });
  }

  List<DocumentSnapshot> _filter(String search) {
    List<DocumentSnapshot> filteredStoreDistrict =
        List.from(_storesDistrict.toList());

    filteredStoreDistrict.retainWhere((store) {
      return store["title"].toUpperCase().contains(search.toUpperCase());
    });

    return filteredStoreDistrict;
  }

  @override
  void dispose() {
    _storesDistrictController.close();
  }
}
