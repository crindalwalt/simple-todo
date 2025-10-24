

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo/views/screens/home_screen.dart';
import 'package:simple_todo/views/screens/splashscreen.dart';

class authWrapper extends StatefulWidget {
  const authWrapper({super.key});

  @override
  State<authWrapper> createState() => _authWrapperState();
}

class _authWrapperState extends State<authWrapper> {
  @override
  Widget build(BuildContext context) {
    final auth=FirebaseAuth.instance;
    if(auth.currentUser==null){
      return WelcomeScreen();
    }
    return HomeScreen();
  }
  }


