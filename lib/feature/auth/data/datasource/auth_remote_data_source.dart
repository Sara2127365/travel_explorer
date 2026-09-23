import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSource(
    this.firebaseAuth,
    this.firestore,
  );

  Future<UserCredential> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final userCredential =
        await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;

    if (user != null) {
      await user.updateDisplayName(name);

      await firestore.collection('users').doc(user.uid).set({
       
        'name': name,
        'email': email,
        
      });
    }

    return userCredential;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

 
  Future<void> resetPassword({
    required String email,
  }) async {
    await firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }
   

}