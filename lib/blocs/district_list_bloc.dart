import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class DistrictListBloc extends BlocBase {
  final _districtController = BehaviorSubject<List>();

  Stream<List> get outDistrict => _districtController.stream;

  List<DocumentSnapshot> _districts = [];
  DocumentSnapshot city;
  DocumentSnapshot store;

  DistrictListBloc({
    this.city,
    this.store,
  }) {
    _addListener();
  }

  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _districtController.add(_districts.toList());
    } else {
      _districtController.add(_filter(search.trim()));
    }
  }

  void _addListener() {
    if (store != null) {
      store.reference.collection("districts").getDocuments().then((value) {
        List<String> uidItems = [];
        var docs = value.documents.toList();
        for (DocumentSnapshot doc in docs) {
          uidItems.add(doc.documentID);
        }

        Firestore.instance
            .collection("cities")
            .document(store.data["city"])
            .collection("districts")
            .orderBy('name')
            .snapshots()
            .listen((snapshot) {
          snapshot.documentChanges.forEach((change) {
            String uid = change.document.documentID;
            if (!uidItems.contains(uid)) {
              switch (change.type) {
                case DocumentChangeType.added:
                  _districts.add(change.document);
                  break;
                case DocumentChangeType.modified:
                  _districts.removeWhere((order) => order.documentID == uid);
                  _districts.add(change.document);
                  break;
                case DocumentChangeType.removed:
                  _districts.removeWhere((order) => order.documentID == uid);
                  break;
              }
            }
          });
          _districtController.add(_districts);
        });
      });
    } else {
      city.reference
          .collection("districts")
          .orderBy('name')
          .snapshots()
          .listen((snapshot) {
        snapshot.documentChanges.forEach((change) {
          String uid = change.document.documentID;

          switch (change.type) {
            case DocumentChangeType.added:
              _districts.add(change.document);
              break;
            case DocumentChangeType.modified:
              _districts.removeWhere((order) => order.documentID == uid);
              _districts.add(change.document);
              break;
            case DocumentChangeType.removed:
              _districts.removeWhere((order) => order.documentID == uid);
              break;
          }
        });
        _districtController.add(_districts);
      });
    }
  }

  List<DocumentSnapshot> _filter(String search) {
    List<DocumentSnapshot> filteredItens = List.from(_districts.toList());

    filteredItens.retainWhere((store) {
      return store["name"].toUpperCase().contains(search.toUpperCase());
    });

    return filteredItens;
  }

  @override
  void dispose() {
    _districtController.close();
  }
}
