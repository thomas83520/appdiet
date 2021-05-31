import 'dart:async';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'models/models.dart';

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
      {firebase_auth.FirebaseAuth firebaseAuth,
      GoogleSignIn googleSignIn,
      AppleSignIn appleSignIn,
      FirebaseFirestore firestore,
      FirebaseFunctions funcitons})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _firestore = firestore ?? FirebaseFirestore.instance,
        _functions =
            funcitons ?? FirebaseFunctions.instanceFor(region: 'europe-west1');

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
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw SignUpFailure();
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
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
      final googleAuth = await googleUser.authentication;
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
    final result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        try {
          final appleIdCredential = result.credential;
          final oAuthProvider = firebase_auth.OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken),
            accessToken:
                String.fromCharCodes(appleIdCredential.authorizationCode),
          );
          final authResult =
              await _firebaseAuth.signInWithCredential(credential);
          final firebaseUser = authResult.user;
          if (scopes.contains(Scope.fullName)) {
            final displayName =
                '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
            await firebaseUser.updateProfile(displayName: displayName);
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
        ));
  }

  Future<User> completeUserSubscription(User user) async {
    await _firestore.collection('patient').doc(user.id).set({
      'name': user.name,
      'firstName': user.firstName,
      'email': user.email,
      'id': user.id,
      'linkFoodPlan': user.linkFoodPlan,
      'linkStorageFolder': user.linkStorageFolder,
      'uidDiet': user.uidDiet,
      'creatingAccount': false,
      'birthDate': user.birthDate,
    });
    return User(
      name: user.name,
      firstName: user.firstName,
      email: user.email,
      id: user.id,
      linkFoodPlan: user.linkFoodPlan,
      linkStorageFolder: user.linkStorageFolder,
      uidDiet: user.uidDiet,
      creatingAccount: false,
      birthDate: user.birthDate,
    );
  }

  Future<void> addUserToWaiting(User user) async {
    await _firestore.collection('accountwaiting').add({
      'name': user.name,
      'firstName': user.firstName,
      'email': user.email,
      'id': user.id,
      'linkFoodPlan': user.linkFoodPlan,
      'linkStorageFolder': user.linkStorageFolder,
      'uidDiet': user.uidDiet,
      'creatingAccount': false,
      'birthDate': user.birthDate,
    });
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
        return _userFromSnapshot(doc.docs.elementAt(0));
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
    );
  }

  Future<bool> isCodeDietAvailable(String codeDiet) async {
    HttpsCallable callable = _functions.httpsCallable('verifyCodeDiet');
    final results = await callable.call(codeDiet);
    final snapshot = await _firestore.collection("dieteticien").where("codeDiet", isEqualTo: codeDiet).get();
    print(snapshot.size);
    return results.data;
  }

  Future<User> initUserInFirestore(
      String uid, String email, String name, String firstName) async {
    await _firestore.collection('patient').doc(uid).set({
      'name': name == null ? '' : name,
      'firstName': firstName == null ? '' : firstName,
      'email': email == null ? '' : email,
      'id': uid,
      'linkFoodPlan': null,
      'linkStorageFolder': null,
      'uidDiet': null,
      'creatingAccount': true,
      'birthDate': null,
    });
    return User(
        email: email == null ? '' : email,
        id: uid,
        name: name == null ? '' : name,
        firstName: name == null ? '' : firstName,
        creatingAccount: true,
        linkFoodPlan: null,
        linkStorageFolder: null,
        uidDiet: null,
        birthDate: null);
  }
}

extension on firebase_auth.User {
  User get toUser {
    return email == null
        ? User(
            id: uid,
            email: "test@email",
            name: "name",
            firstName: "test",
            creatingAccount: false,
            linkStorageFolder: null,
            linkFoodPlan: null,
            uidDiet: null,
            birthDate: null,
          )
        : User(
            id: uid,
            email: email,
            name: displayName == null
                ? ""
                : displayName.substring(displayName.indexOf(" ") + 1),
            firstName: displayName == null
                ? ""
                : displayName.substring(0, displayName.indexOf(" ")),
            creatingAccount: false,
            linkStorageFolder: null,
            linkFoodPlan: null,
            uidDiet: null,
            birthDate: null,
          );
  }
}
