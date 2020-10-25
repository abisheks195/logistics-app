import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  FirebaseDatabase database = new FirebaseDatabase(
    databaseURL: "https://easygo-d2af6.firebaseio.com/",
  );
  DatabaseReference userRef() {
    return database.reference().child('user');
  }
}
