import 'package:flutter/material.dart';
import 'category.dart';
import 'wordcard.dart';
import 'my_setting.dart';
import 'dictionary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Widget? tabView;
  SharedPreferences? prefs;
  late PageController pageController;
  int currentIndex = 0;

  Future<SharedPreferences> initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final level = prefs.getInt('level');
    if (level == null) {
      prefs.setInt('level', 1);
      prefs.setInt('count', 50);
      prefs.setBool('showcollins', true);
      prefs.setBool('sentence', true);
      prefs.setBool('showCn', true);
      prefs.setBool('autoplay', false);
      prefs.setBool('en_ph', true);
    }
    prefs.remove('studied');
    final studied = prefs.getString('studied');
    if (studied == null) {
      prefs.setString('studied', '');
      prefs.setInt('studying', 0);
    }
    return prefs;
  }

  @override
  void initState() {
    super.initState();
    pageController =
         PageController(initialPage: currentIndex, keepPage: true);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    // pageController.jumpToPage(index);
    if ((currentIndex - index).abs() == 1) {
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      pageController.jumpToPage(index);
    }
  }

  pageChanged(int page) {
    setState(() {
      currentIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body:  FutureBuilder(
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return  PageView(
                controller: pageController,
                onPageChanged: pageChanged,
                children: <Widget>[
                   RememberVocab(prefs: snapshot.data as SharedPreferences?),
                   const Dictionary(),
                   WordList(prefs: snapshot.data as SharedPreferences?),
                   Mine(prefs: snapshot.data as SharedPreferences?),
                ],
              );
            }
            return  const Center(
              child:  CircularProgressIndicator(),
            );
          },
          future: initPrefs(),
        ),
        bottomNavigationBar:  BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: _onTap,
            type: BottomNavigationBarType.fixed,
            iconSize: 24.0,
            items: const [
               BottomNavigationBarItem(
                icon:  Icon(
                  Icons.home,
                  size: 24.0,
                ),
                label: '背词',
              ),
               BottomNavigationBarItem(
                icon:  Icon(
                  Icons.g_translate,
                  size: 24.0,
                ),
                 label: '词典',
              ),
               BottomNavigationBarItem(
                icon:  Icon(
                  Icons.library_books,
                  size: 24.0,
                ),
                 label: '记录',
              ),
               BottomNavigationBarItem(
                icon:  Icon(
                  Icons.account_circle,
                  size: 24.0,
                ),
                 label: '我的',
              ),
            ]));
  }
}
