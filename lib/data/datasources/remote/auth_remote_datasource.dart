import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithEmail(String email, String password);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  late final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  }) {
    googleSignIn = GoogleSignIn();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;

    final doc = await firestore.collection('users').doc(user.uid).get();
    
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }

    final userModel = UserModel(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      createdAt: DateTime.now(),
    );

    await firestore.collection('users').doc(user.uid).set(userModel.toJson());
    return userModel;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user!;

      final userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );

      // Save or update user in Firestore
      await firestore.collection('users').doc(user.uid).set(
        userModel.toJson(),
        SetOptions(merge: true),
      );

      return userModel;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      final doc = await firestore.collection('users').doc(user.uid).get();
      
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }

      final userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );

      await firestore.collection('users').doc(user.uid).set(userModel.toJson());
      return userModel;
    } catch (e) {
      throw Exception('Failed to sign in with email: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      firebaseAuth.signOut(),
      googleSignIn.signOut(),
    ]);
  }
}