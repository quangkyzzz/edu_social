import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreInstance {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  FireStoreInstance._internalConstructor();

  static final FireStoreInstance _fireStoreInstance = FireStoreInstance._internalConstructor();

  static FireStoreInstance get getInstance => _fireStoreInstance;
}
