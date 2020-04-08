import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class StoreSpecialtyListBloc extends BlocBase {
  final _storesSpecialtyController = BehaviorSubject<List>();

  Stream<List> get outStoreSpecialty => _storesSpecialtyController.stream;

  List<DocumentSnapshot> _storesSpecialty = [];
  final DocumentSnapshot store;

  StoreSpecialtyListBloc({this.store}) {
    _addStoreListener();
  }

  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _storesSpecialtyController.add(_storesSpecialty.toList());
    } else {
      _storesSpecialtyController.add(_filter(search.trim()));
    }
  }

  void _addStoreListener() {
    store.reference.collection("specialties").snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _storesSpecialty.add(change.document);
            break;
          case DocumentChangeType.modified:
            _storesSpecialty.removeWhere((order) => order.documentID == uid);
            _storesSpecialty.add(change.document);
            break;
          case DocumentChangeType.removed:
            _storesSpecialty.removeWhere((order) => order.documentID == uid);
            break;
        }
      });
      _storesSpecialtyController.add(_storesSpecialty);
    });
  }

  List<DocumentSnapshot> _filter(String search) {
    List<DocumentSnapshot> filteredStoreSpecialty =
        List.from(_storesSpecialty.toList());

    filteredStoreSpecialty.retainWhere((store) {
      return store["title"].toUpperCase().contains(search.toUpperCase());
    });

    return filteredStoreSpecialty;
  }

  @override
  void dispose() {
    _storesSpecialtyController.close();
  }
}
