import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo/firebase_options.dart';
import 'package:simple_todo/views/screens/home_screen.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(SimpleTodo());
}


class SimpleTodo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Simple Todo",
      debugShowCheckedModeBanner: false,
      home: HomeScreen() ,
    );
    
  }
}


