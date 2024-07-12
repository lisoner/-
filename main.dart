import 'package:flutter/material.dart';
import 'pages/login_in.dart';


void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '四级单词记忆利器',
      theme: ThemeData(
        primaryIconTheme: const IconThemeData(color: Colors.white),
        brightness: Brightness.light,
        primaryColor: Colors.blue, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan[300]),
      ),
      debugShowCheckedModeBanner: false,
      home: LogininPage(),
    );
  }
}
