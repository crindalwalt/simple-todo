import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo/controllers/authenticationprovider.dart';
import 'package:simple_todo/controllers/authwrapper.dart';
import 'package:simple_todo/controllers/todo_provider.dart';
import 'package:simple_todo/firebase_options.dart';
import 'package:simple_todo/views/screens/home_screen.dart';
import 'package:simple_todo/views/screens/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(SimpleTodo());
}

class SimpleTodo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodoProvider()),
        ChangeNotifierProvider(create: (context)=>AuthenticationProvider())
      ],
      child: MaterialApp(
        title: "Simple Todo",
        debugShowCheckedModeBanner: false,
        home:authWrapper(),
      ),
    );
  }
}
