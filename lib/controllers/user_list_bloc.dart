import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../globals.dart';

class UserListBloc extends BlocBase {
  final _usersController = BehaviorSubject<List>();

  Stream<List> get outUsers => _usersController.stream;

  List<DocumentSnapshot> _users = [];

  Firestore _firestore = Firestore.instance;

  UserListBloc() {
    _addUserListener();
  }

  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _usersController.add(_users.toList());
    } else {
      _usersController.add(_filter(search.trim()));
    }
  }

  void _addUserListener() {
    List<String> types = [];
    types.add("user");
    types.add("operator");
    if (isAdmin) types.add("admin");

    _firestore
        .collection("users")
        .orderBy('name')
        .where("type", whereIn: types)
        .snapshots()
        .listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _users.add(change.document);
            break;
          case DocumentChangeType.modified:
            _users.removeWhere((order) => order.documentID == uid);
            _users.add(change.document);
            break;
          case DocumentChangeType.removed:
            _users.removeWhere((order) => order.documentID == uid);
            break;
        }
      });
      _usersController.add(_users);
    });
  }

  List<DocumentSnapshot> _filter(String search) {
    List<DocumentSnapshot> filteredUsers = List.from(_users.toList());

    filteredUsers.retainWhere((store) {
      return store["name"].toUpperCase().contains(search.toUpperCase());
    });

    return filteredUsers;
  }

  @override
  void dispose() {
    _usersController.close();
  }
}
