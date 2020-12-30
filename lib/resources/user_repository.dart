import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Auth {
  Future<User> signIn(String email, String password);
  Future<User> signUp(String email, String password, {String username});
  Future<void> signOut();
  Future<String> resetPassword(String email);
}

class User {
  final FirebaseUser user;

  final String message;

  User({this.user, this.message = "N/A"});
}

enum STATE { SUCCESS, ERROR }

class UserRepository implements Auth {
  STATE state;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<User> signUp(String email, String password, {String username}) async {
    print("Signing Up...");
    FirebaseUser user;
    try {
      user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      UserUpdateInfo info = new UserUpdateInfo();
      info.displayName = username;
      user.updateProfile(info);
      state = STATE.SUCCESS;
    } catch (e) {
      print("An error occured while trying to create an Account");
      state = STATE.ERROR;
      return User(message: e.message);
    }
    try {
      await user.sendEmailVerification();
      state = STATE.SUCCESS;
      return User(user: user, message: "Signed up successfully");
    } catch (e) {
      print("An error occured while trying to send email verification");
      state = STATE.ERROR;
      return User(message: e.message);
    }
  }

  Future<User> sendVerficationLink(FirebaseUser user) async {
    try {
      await user.sendEmailVerification();
      state = STATE.SUCCESS;
      return User(user: user, message: "Signed up successfully");
    } catch (e) {
      print("An error occured while trying to send email verification");
      state = STATE.ERROR;
      return User(message: e.message);
    }
  }

  @override
  Future<User> signIn(String email, String password) async {
    FirebaseUser user;
    try {
      user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      state = STATE.SUCCESS;
    } catch (e) {
      print("An error occured while trying to send email verification");
      state = STATE.ERROR;
      return User(message: e.message);
    }
    if (user.isEmailVerified) {
      return User(user: user, message: "Signed in successfully");
    }
    return User(
        user: user,
        message: "Please check your mail for the verification link");
  }

  @override
  Future<String> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      state = STATE.SUCCESS;
      return "Reset Password link sent";
    } catch (e) {
      print("An error occured while trying to send reset link");
      state = STATE.ERROR;
      return e.message;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<User> getUser() async {
    return (User(user: await _firebaseAuth.currentUser()));
  }
}
