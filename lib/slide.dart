import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'Home.dart';
import 'page2.dart';
import 'sign_in.dart';
import 'login.dart';
class Sliding extends StatefulWidget {
  @override
  static String tag = 'slide-page';
  SlidingState createState() => SlidingState();
}

class SlidingState extends State<Sliding> {
  
  static final List<Widget> imgSlider = [Home(),Page2()];
  final CarouselSlider autoPlayImage = CarouselSlider(
    options: CarouselOptions(
      height: 1000.0,
      viewportFraction: 1,
      aspectRatio: 16 / 9,
      enableInfiniteScroll: false,
    ),
    items: imgSlider.map((i) {
      return i;
    }).toList(),
  );
  void handleClick(String value) {
      switch (value) {
        case 'Logout':
          signOutGoogle();

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
            return LoginPage();
          }), ModalRoute.withName('/'));
          break;
        case 'Settings':
          break;
      }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gudang'),
          actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        child: autoPlayImage,
      ),
    );
  }
}
