import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ServiceListBloc extends BlocBase {
  final _serviceController = BehaviorSubject<List>();
  DocumentSnapshot store;

  Stream<List> get outService => _serviceController.stream;

  List<DocumentSnapshot> _services = [];

  Firestore _firestore = Firestore.instance;

  ServiceListBloc({this.store}) {
    _addListener();
  }

  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _serviceController.add(_services.toList());
    } else {
      _serviceController.add(_filter(search.trim()));
    }
  }

  void _addListener() {
    if (store != null) {
      store.reference.collection("services").getDocuments().then((value) {
        List<String> uidItems = [];
        var docs = value.documents.toList();
        for (DocumentSnapshot doc in docs) {
          uidItems.add(doc.documentID);
        }

        _firestore
            .collection("services")
            .orderBy('name')
            .snapshots()
            .listen((snapshot) {
          snapshot.documentChanges.forEach((change) {
            String uid = change.document.documentID;
            if (!uidItems.contains(uid)) {
              switch (change.type) {
                case DocumentChangeType.added:
                  _services.add(change.document);
                  break;
                case DocumentChangeType.modified:
                  _services.removeWhere((order) => order.documentID == uid);
                  _services.add(change.document);
                  break;
                case DocumentChangeType.removed:
                  _services.removeWhere((order) => order.documentID == uid);
                  break;
              }
            }
          });
          _serviceController.add(_services);
        });
      });
    } else {
      _firestore
          .collection("services")
          .orderBy('name')
          .snapshots()
          .listen((snapshot) {
        snapshot.documentChanges.forEach((change) {
          String uid = change.document.documentID;

          switch (change.type) {
            case DocumentChangeType.added:
              _services.add(change.document);
              break;
            case DocumentChangeType.modified:
              _services.removeWhere((order) => order.documentID == uid);
              _services.add(change.document);
              break;
            case DocumentChangeType.removed:
              _services.removeWhere((order) => order.documentID == uid);
              break;
          }
        });
        _serviceController.add(_services);
      });
    }
  }

  List<DocumentSnapshot> _filter(String search) {
    List<DocumentSnapshot> filteredItens = List.from(_services.toList());

    filteredItens.retainWhere((service) {
      return service["name"].toUpperCase().contains(search.toUpperCase());
    });

    return filteredItens;
  }

  @override
  void dispose() {
    _serviceController.close();
  }
}
