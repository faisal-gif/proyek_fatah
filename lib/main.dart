//kode utama Aplikasi tampilan awal
import 'package:flutter/material.dart';
import 'slide.dart';
import 'Home.dart';
import 'login.dart';

//package letak folder Anda
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    Home.tag: (context) => Home(),
    Sliding.tag: (context) => Sliding(),
    
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
   
      theme: ThemeData(
        primarySwatch: Colors.indigo
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}
