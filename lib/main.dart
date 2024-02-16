import 'package:flutter/material.dart';

void main() {
  runApp(App()); // import 된 함수
}

class App extends StatelessWidget{ // root
  @override
  Widget build(BuildContext context) {
    /*1. material -> 구글의 디자인 시스템
      2. cupertino -> 애플의 디자인 시스템
      아무래도 구글 개발이라 Material이 추천
    */
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hello Flutter!"),
          backgroundColor: Color.fromARGB(143, 80, 11, 199),
          centerTitle: true,
        ),
        body: Center(
          child: Text("hello world!"),
        ),
      ),
    );
  } 
}