import 'package:flutter/material.dart';
import 'package:note_app_withphpapi/app/auth/signup_screen.dart';
import 'package:note_app_withphpapi/app/home_screen.dart';
import 'package:note_app_withphpapi/app/note/addnote.dart';
import 'package:note_app_withphpapi/app/note/editnote.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/auth/login_screen.dart';

late SharedPreferences sharedPreferences;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();///هاض الحكي كلو عشان احفظ تسجيل الدخول
  ///والشيرد بريف بتضل موجوده بالكاش بالتلفون ما بتنحذف الا لما احذف التطبيق
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course php rest API',

      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // initialRoute: "/login",
      initialRoute: sharedPreferences.getString("id") == null ? "login": "home" ,
      routes: {
        "login" : (context) => LoginScreen(),
        "signup": (context) => SignUpScreen(),
        "home": (context) => HomeScreen(),
        "addnote": (context)=> AddNote(),
        "editnote": (context)=> EditNote(),
      },
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

