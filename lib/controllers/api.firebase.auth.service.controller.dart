// import 'package:firebase_auth/firebase_auth.dart';
//
// class ApiAuthFirebaseAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Future<User?> signInWithEmailPassword(String email, String password) async {
//     try {
//       final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         print('Wrong password provided for that user.');
//       }
//       return null;
//     }
//   }
//
//   // Inscription avec email et mot de passe
//   Future<User?> createUserWithEmailPassword(String email, String password) async {
//     try {
//       final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       print('Error: ${e.message}');
//       return null;
//     }
//   }
//
//   // Déconnexion
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
//
//   // Récupérer l'utilisateur actuel
//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }
// }
