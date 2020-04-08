import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class CityListBloc extends BlocBase {
  final _cityController = BehaviorSubject<List>();

  Stream<List> get outCities => _cityController.stream;

  List<DocumentSnapshot> _cities = [];

  Firestore _firestore = Firestore.instance;

  CityListBloc() {
    _addListener();
  }

  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _cityController.add(_cities.toList());
    } else {
      _cityController.add(_filter(search.trim()));
    }
  }

  void _addListener() {
    _firestore
        .collection("cities")
        .orderBy('name')
        .snapshots()
        .listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _cities.add(change.document);
            break;
          case DocumentChangeType.modified:
            _cities.removeWhere((order) => order.documentID == uid);
            _cities.add(change.document);
            break;
          case DocumentChangeType.removed:
            _cities.removeWhere((order) => order.documentID == uid);
            break;
        }
      });
      _cityController.add(_cities);
    });
  }

  List<DocumentSnapshot> _filter(String search) {
    List<DocumentSnapshot> filteredItens = List.from(_cities.toList());

    filteredItens.retainWhere((store) {
      return store["name"].toUpperCase().contains(search.toUpperCase());
    });

    return filteredItens;
  }

  @override
  void dispose() {
    _cityController.close();
  }
}
