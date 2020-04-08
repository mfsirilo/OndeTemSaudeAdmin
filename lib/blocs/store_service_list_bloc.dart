import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class StoreServiceListBloc extends BlocBase {
  final _storesServiceController = BehaviorSubject<List>();

  Stream<List> get outStoreService => _storesServiceController.stream;

  List<DocumentSnapshot> _storesService = [];
  final DocumentSnapshot store;

  StoreServiceListBloc({this.store}) {
    _addStoreListener();
  }

  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _storesServiceController.add(_storesService.toList());
    } else {
      _storesServiceController.add(_filter(search.trim()));
    }
  }

  void _addStoreListener() {
    store.reference.collection("services").snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _storesService.add(change.document);
            break;
          case DocumentChangeType.modified:
            _storesService.removeWhere((order) => order.documentID == uid);
            _storesService.add(change.document);
            break;
          case DocumentChangeType.removed:
            _storesService.removeWhere((order) => order.documentID == uid);
            break;
        }
      });
      _storesServiceController.add(_storesService);
    });
  }

  List<DocumentSnapshot> _filter(String search) {
    List<DocumentSnapshot> filteredStoreService =
        List.from(_storesService.toList());

    filteredStoreService.retainWhere((store) {
      return store["title"].toUpperCase().contains(search.toUpperCase());
    });

    return filteredStoreService;
  }

  @override
  void dispose() {
    _storesServiceController.close();
  }
}
