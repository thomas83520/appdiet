import 'dart:async';

import 'package:appdiet/data/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
//import 'package:the_apple_sign_in/the_apple_sign_in.dart';


/// Thrown if during the sign up process if a failure occurs.
class SignUpFailure implements Exception {}

/// Thrown during the login process if a failure occurs.
class LogInWithEmailAndPasswordFailure implements Exception {}

/// Thrown during the sign in with google process if a failure occurs.
class LogInWithGoogleFailure implements Exception {}

class LoginWithAppleFailure implements Exception {}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository(
      )
      : _firebaseAuth = firebase_auth.FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn.standard(),
        _firestore = FirebaseFirestore.instance,
        _functions = FirebaseFunctions.instanceFor(region: 'europe-west1');

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? User.empty : firebaseUser.toUser;
    });
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpFailure] if an exception occurs.
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw SignUpFailure();
    }
  }

Future<void> sendResetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }
  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on Exception {
      throw LogInWithGoogleFailure();
    }
  }

  Future<void> logInWithApple({List<Scope> scopes = const []}) async {
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        try {
          final appleIdCredential = result.credential;
          final oAuthProvider = firebase_auth.OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential!.identityToken!),
            accessToken:
                String.fromCharCodes(appleIdCredential.authorizationCode!),
          );
          final authResult =
              await _firebaseAuth.signInWithCredential(credential);
          final firebaseUser = authResult.user;
          if (scopes.contains(Scope.fullName)) {
            final displayName =
                '${appleIdCredential.fullName!.givenName} ${appleIdCredential.fullName!.familyName}';
            await firebaseUser!.updateDisplayName(displayName);
          }
        } on Exception {
          throw LoginWithAppleFailure();
        }
        break;

      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );
      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }

  Future<User> getUserFromUid(String uid) {
    return _firestore.collection('patient').doc(uid).get().then((snap) => User(
          name: snap.get('name'),
          firstName: snap.get('firstName'),
          email: snap.get('email'),
          id: snap.id,
          linkFoodPlan: snap.get('linkFoodPlan'),
          linkStorageFolder: snap.get('linkStorageFolder'),
          uidDiet: snap.get('uidDiet'),
          creatingAccount: snap.get('creatingAccount'),
          birthDate: snap.get('birthDate'),
          suivi : snap.get("suivi")
        ));
  }

  Future<User> completeUserSubscription(User user,String uidUser) async {
    await _firestore.collection('patient').doc(uidUser).set({
      'name': user.name.toUpperCase(),
      'firstName': user.firstName,
      'email': user.email,
      'id': uidUser,
      'linkFoodPlan': user.linkFoodPlan,
      'linkStorageFolder': user.linkStorageFolder,
      'uidDiet': user.uidDiet,
      'creatingAccount': false,
      'birthDate': user.birthDate,
      'suivi' : "Suivi en cours"
    });
    return User(
      name: user.name.toUpperCase(),
      firstName: user.firstName,
      email: user.email,
      id: uidUser,
      linkFoodPlan: user.linkFoodPlan,
      linkStorageFolder: user.linkStorageFolder,
      uidDiet: user.uidDiet,
      creatingAccount: false,
      birthDate: user.birthDate,
      suivi: user.suivi
    );
  }

  Future<void> addUserToWaiting(User user) async {
    await _firestore.collection('accountwaiting').add({
      'name': user.name.toUpperCase(),
      'firstName': user.firstName,
      'email': user.email,
      'id': user.id,
      'linkFoodPlan': user.linkFoodPlan,
      'linkStorageFolder': user.linkStorageFolder,
      'uidDiet': user.uidDiet,
      'creatingAccount': true,
      'birthDate': user.birthDate,
      'suivi' :"Suivi en cours",
    });
  }

  Future<void> deleteUserFromWaiting(String id) async {
    await _firestore.collection('accountwaiting').doc(id).delete();
  }

  Future<bool> isUserInFirestore(String uid) {
    return _firestore.collection('patient').doc(uid).get().then((doc) {
      if (doc.exists)
        return true;
      else
        return false;
    });
  }

  Future<User> getUserFromWaiting(String email) {
    return _firestore
        .collection('accountwaiting')
        .where('email', isEqualTo: email)
        .get()
        .then((doc) {
      if (doc.size == 1)
        return _userFromSnapshot(doc.docs.first);
      else
        return User.empty;
    });
  }

  User _userFromSnapshot(DocumentSnapshot snap) {
    return User(
      name: snap.get('name'),
      firstName: snap.get('firstName'),
      email: snap.get('email'),
      id: snap.id,
      linkFoodPlan: snap.get('linkFoodPlan'),
      linkStorageFolder: snap.get('linkStorageFolder'),
      uidDiet: snap.get('uidDiet'),
      creatingAccount: snap.get('creatingAccount'),
      birthDate: snap.get('birthDate'),
      suivi: snap.get('suivi')
    );
  }

  Future<bool> isCodeDietAvailable(String codeDiet) async {
    HttpsCallable callable = _functions.httpsCallable('verifyCodeDiet');
    final results = await callable.call(codeDiet);
    return results.data;
  }

  Future<User> initUserInFirestore(
      String uid, String email, String name, String firstName) async {
    await _firestore.collection('patient').doc(uid).set({
      'name': name.toUpperCase(),
      'firstName':  firstName,
      'email': email,
      'id': uid,
      'linkFoodPlan': "null",
      'linkStorageFolder': "null",
      'uidDiet': "null",
      'creatingAccount': true,
      'birthDate': "null",
      'suivi' : "Suivi en cours"
    });
    return User(
        email:  email,
        id: uid,
        name: name.toUpperCase(),
        firstName: firstName,
        creatingAccount: true,
        linkFoodPlan: "null",
        linkStorageFolder: "null",
        uidDiet: "null",
        birthDate: "null",
        suivi: "Suivi en cours");
  }
}

extension on firebase_auth.User {
  User get toUser {
    String prenom = "";//displayName!.substring(0, displayName!.indexOf(" "))
    String nom =""; //displayName!.substring(displayName!.indexOf(" ") + 1),


    if(this.displayName!=null)
    {
      if(this.displayName!.length>0){
        prenom = displayName!.substring(0, displayName!.indexOf(" "));
        nom = displayName!.substring(displayName!.indexOf(" ") + 1);
      }
    }
    return email == null
        ? User(
            id: uid,
            email: "test@email",
            name: "name",
            firstName: "test",
            creatingAccount: false,
            linkStorageFolder: "null",
            linkFoodPlan: "null",
            uidDiet: "null",
            birthDate: "null",
            suivi: "null",
          )
        : User(
            id: uid,
            email: email == null ? '' : email!,
            name: nom,
            firstName: prenom,
            creatingAccount: false,
            linkStorageFolder: "null",
            linkFoodPlan: "null",
            uidDiet: "null",
            birthDate: "null",
            suivi: "null",
          );
  }
}
