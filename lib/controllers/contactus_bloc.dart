import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ContactUsBloc extends BlocBase {
  final _contactUsController = BehaviorSubject<List>();

  Stream<List> get outContactUs => _contactUsController.stream;

  Firestore _firestore = Firestore.instance;

  List<DocumentSnapshot> _contactUs = [];

  ContactUsBloc() {
    _addContactUsListener();
  }

  void _addContactUsListener() {
    _firestore.collection("messages").snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String oid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _contactUs.add(change.document);
            break;
          case DocumentChangeType.modified:
            _contactUs.removeWhere((message) => message.documentID == oid);
            _contactUs.add(change.document);
            break;
          case DocumentChangeType.removed:
            _contactUs.removeWhere((message) => message.documentID == oid);
            break;
        }
      });
      _contactUsController.add(_contactUs);
    });
  }

  Future<List<DocumentSnapshot>> getMessages() async {
    return _contactUs;
  }

  @override
  void dispose() {
    _contactUsController.close();
  }
}
