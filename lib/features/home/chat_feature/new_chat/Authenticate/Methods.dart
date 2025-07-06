import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createAccount(String name, String email, String password, String userID) async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    print("Account created Succesfull");

    // userCrendetial.user!.updateDisplayName(name);

    await _firestore.collection('users').doc(userID).set({
      "name": name,
      "email": email,
      "status": "Unavalible",
      "uid": userID,
    });
    print('qqq create account:');
    // return userCrendetial.user;
  } catch (e) {
    print(e);
    return null;
  }
}

// Future<void> logIn(String email, String password) async {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   try {
//     UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

//     print("Login Sucessfull");
//     _firestore.collection('users').doc(_auth.currentUser!.uid).get().then((value) => userCredential.user!.updateDisplayName(value['name']));

//     return userCredential.user;
//   } catch (e) {
//     print(e);
//     return null;
//   }
// }

// Future logOut(BuildContext context) async {
//   FirebaseAuth _auth = FirebaseAuth.instance;

//   try {
//     await _auth.signOut().then((value) {
//       Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
//     });
//   } catch (e) {
//     print("error");
//   }
// }
