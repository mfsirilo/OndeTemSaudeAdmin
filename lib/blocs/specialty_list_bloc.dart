import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class SpecialtyListBloc extends BlocBase {
  final _specialtiesController = BehaviorSubject<List>();
  DocumentSnapshot store;

  Stream<List> get outSpecialties => _specialtiesController.stream;

  List<DocumentSnapshot> _specialties = [];

  Firestore _firestore = Firestore.instance;

  SpecialtyListBloc({this.store}) {
    _addListener();
  }

  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _specialtiesController.add(_specialties.toList());
    } else {
      _specialtiesController.add(_filter(search.trim()));
    }
  }

  void _addListener() {
    if (store != null) {
      store.reference.collection("specialties").getDocuments().then((value) {
        List<String> uidItems = [];
        var docs = value.documents.toList();
        for (DocumentSnapshot doc in docs) {
          uidItems.add(doc.documentID);
        }

        _firestore
            .collection("specialties")
            .orderBy('name')
            .snapshots()
            .listen((snapshot) {
          snapshot.documentChanges.forEach((change) {
            String uid = change.document.documentID;
            if (!uidItems.contains(uid)) {
              switch (change.type) {
                case DocumentChangeType.added:
                  _specialties.add(change.document);
                  break;
                case DocumentChangeType.modified:
                  _specialties.removeWhere((order) => order.documentID == uid);
                  _specialties.add(change.document);
                  break;
                case DocumentChangeType.removed:
                  _specialties.removeWhere((order) => order.documentID == uid);
                  break;
              }
            }
          });
          _specialtiesController.add(_specialties);
        });
      });
    } else {
      _firestore
          .collection("specialties")
          .orderBy('name')
          .snapshots()
          .listen((snapshot) {
        snapshot.documentChanges.forEach((change) {
          String uid = change.document.documentID;

          switch (change.type) {
            case DocumentChangeType.added:
              _specialties.add(change.document);
              break;
            case DocumentChangeType.modified:
              _specialties.removeWhere((order) => order.documentID == uid);
              _specialties.add(change.document);
              break;
            case DocumentChangeType.removed:
              _specialties.removeWhere((order) => order.documentID == uid);
              break;
          }
        });
        _specialtiesController.add(_specialties);
      });
    }
  }

  List<DocumentSnapshot> _filter(String search) {
    List<DocumentSnapshot> filteredItens = List.from(_specialties.toList());

    filteredItens.retainWhere((specialties) {
      return specialties["name"].toUpperCase().contains(search.toUpperCase());
    });

    return filteredItens;
  }

  @override
  void dispose() {
    _specialtiesController.close();
  }
}
