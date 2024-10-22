
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_session/d_session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rent_apps/models/account.dart';

class AuthSource {
  static Future<String> signUp(
    String email, 
    String userName, 
    String password,
    ) async{
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        Account account = Account(
          uid: credential.user!.uid, 
          email: email, 
          name: userName,
        );
        await FirebaseFirestore.instance.collection('Users').doc(account.uid).set(account.toJson());
        return 'success';
      } on FirebaseAuthException catch (e) {
        /* REMAINING TO UPDATE THIS CODE TO HANDLING WEAK PASSWORD WHILE SETTING EMAIL ENUMERATION IN ON IN FIREBASE SETTINGS */
        if (e.code == 'weak-password') {
          return 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          return 'The account already exists for that email.';
        }
        log(e.toString());
        return 'something wrong';
      } catch (e) {
        log(e.toString());
        return e.toString();
      }
  }

  static Future<String> signIn(
    String email,  
    String password,
    ) async{
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
        );
        final accountDoc = await FirebaseFirestore.instance.collection('Users').doc(credential.user!.uid).get();
        await DSession.setUser(Map.from(accountDoc.data()!));
        return 'success';
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          return 'Wrong password provided for that user.';
        }
        log(e.toString());
        return 'something wrong';
      }catch (e) {
        log(e.toString());
        return e.toString();
      }
  }

  static Future<String> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      if (newPassword != confirmPassword) return 'Password and Confirm Password not match';
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return 'User Not Found';

      String email = user.email!;
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: currentPassword);
      try{
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        return 'success';
      } on FirebaseAuthException catch (e) {
        log(e.message.toString());
        return ("Error: ${e.message}");
      }
    }
    catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  static Future<String> editProfile(
    Map<String, dynamic> data
  ) async {
    try {
      if (data['name'].isEmpty) return 'Name must be filled';
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) return 'User Not Found';

      CollectionReference collectionReference = FirebaseFirestore.instance.collection('Users');
      await collectionReference.doc(user.uid).update(data);
      Map<String, dynamic>? userSessionData = await DSession.getUser();
      if (userSessionData != null) {
        Account account = Account.fromJson(Map.from(userSessionData));
        account.name = data['name'];
        await DSession.removeUser();
        await DSession.setUser(Map.from(account.toJson()));
      }

      return 'success';
    }
    catch (e) {
      log(e.toString());
      return e.toString();
    }
  }
}