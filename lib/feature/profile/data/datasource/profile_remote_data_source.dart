import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  ProfileRemoteDataSource(this.firebaseAuth, this.firebaseFirestore);

  Future<Map<String, dynamic>?> getUser() async {
    final user = firebaseAuth.currentUser;

    if (user == null) return null;

    final document = await firebaseFirestore.collection('users').doc(user.uid).get();

    return  document.data();
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
