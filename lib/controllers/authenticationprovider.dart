
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  Future<bool> loginToAccount({required email,required password})async{
    try{
      final UserCredential login=await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    }catch(e){
      return false;
    }
  }


  Future<bool> registerToAccount({required name,required email,required password})async{
    try{
      final UserCredential register= await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    }catch(e){
      return false;
    }
  }
}