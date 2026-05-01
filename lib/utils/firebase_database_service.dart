// firebase_database_service.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseService {
  FirebaseDatabaseService._();

  static final DatabaseReference ref = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://twafok-aa258-default-rtdb.firebaseio.com/",
  ).ref();
}
