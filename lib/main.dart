import 'package:election_exit_poll_620710650/pages/home_page.dart';
import 'package:election_exit_poll_620710650/pages/result_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        ResultPage.routeName: (context) => const ResultPage()
      },
      initialRoute: HomePage.routeName,
    );
  }
}